require 'uri'
require 'net/http'
require 'sinatra/base'
require_relative 'stream'
require 'thread'
require 'open3'
require 'timeout'

module Recorder
  # This class responds to http requests coming in from teal to record a stream.
  #   A call can be to start a show, end a show.
  #   At the end of the recording, recorder uploads the file back to the server.
  class Recorder < Sinatra::Base
    API_URI = 'nginx:23021'.freeze
    LIMIT = 2

    configure do
      set :port, 80
      @@recording = []
    end

    post '/start-recording' do
      p 'start record request received'
      stream = Stream.new
      stream.episode_id = params['episode_id']
      stream.user_key = params['user_key']
      stream.stream_url = params['stream_url']
      stream.delay = params['delay'].to_i | 12
      stream.delay = 30 if stream.delay.to_i > 30
      stream.delay = 0.1 if stream.delay.to_i <= 0
      halt 202 if currently_recording?(params['episode_id'])

      halt 400 if @@recording.length == LIMIT # limit reached

      stream.thread = Thread.new { timeout(10_800) { record(stream) } }
      @@recording.push(stream)
      @@recording.each do |s|
        p "Stream ep id is: #{s.episode_id}"
      end
      p 'started recording'
      stream.delay.to_s
    end

    post '/end-recording' do
      p 'stop record request received'
      halt 400 unless currently_recording?(params['episode_id'])
      stream = @@recording.find { |s| s.episode_id.eql?(params['episode_id']) }
      sleep(stream.delay)
      @@recording.delete stream
      stream.thread.exit # stop the thread
      result = stream.thread.join

      if result.instance_of? Exception # check if there was an exeption
        p "failed to process episode #{stream.episode_id} (exception in thread)"
        file = File.join '/tmp', stream.episode_id
        File.delete(file)
      end
      p 'stopped recording'
      upload_stream(stream)
      p 'uploaded recording'
      stream.delay.to_s
    end

    private

    def currently_recording?(episode_id)
      value = false
      p 'checking currently_recording?'
      @@recording.each do |s|
        p "Stream ep id is: #{s.episode_id}, ep id expected is: #{episode_id}"
        value = true if s.episode_id.eql?(episode_id)
      end
      value
    end

    def upload_stream(stream)
      tmp_path = File.join '/tmp', stream.episode_id
      encoding, s2 = Open3.capture2e("curl --data-binary '@#{tmp_path}'\
        -H 'Content-Type: application/octet-stream'\
        -X POST\
        --header 'teal-api-key: #{stream.user_key}'\
        #{API_URI}/episodes/#{stream.episode_id}/simpleupload")
      p "uploaded episode #{stream.episode_id}" if s2.to_i == 0
      p "failed upload episode #{stream.episode_id}" if s2.to_i != 0
      p encoding
      File.delete(tmp_path)
      halt 400 if s2.to_i != 0
    end

    def record(stream)
      sleep(stream.delay)
      uri = URI(stream.stream_url)
      tmp_path = File.join '/tmp', stream.episode_id
      use_ssl = uri.scheme == 'https'
      http = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl)
      request = Net::HTTP::Get.new uri.request_uri
      http.request request do |response|
        File.open tmp_path, 'w' do |io|
          response.read_body { |chunk| io.write chunk }
        end
      end
    end

    def shut_down
      puts 'Shutting down gracefully...'
      @@recording.each do |s|
        s.thread.exit
        tmp_path = File.join '/tmp', s.episode_id
        File.delete(tmp_path)
      end
      puts 'Now ready to exit.'
      sleep 1
    end

    Signal.trap('INT') do
      shut_down
      exit
    end

    Signal.trap('TERM') do
      shut_down
      exit
    end

    run! if app_file == $0
  end
end
