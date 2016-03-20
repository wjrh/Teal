require 'tmpdir'
require 'uri'
require 'net/http'

module Teal
  class Recorder

  	currently_recording = {}

		def download_to_tmp_path(url)
		  uri = URI(url)
		  tmp_path = File.join Dir.mktmpdir(uri.to_s.gsub(/\W/, '_')), "out"
		  Net::HTTP.start(uri.host, uri.port, :use_ssl => (uri.scheme == 'https')) do |http|
		    request = Net::HTTP::Get.new uri.request_uri
		    http.request request do |response|
		      File.open tmp_path, 'w' do |io|
		        response.read_body do |chunk|
		          io.write chunk
		        end
		      end
		    end
		  end
		  tmp_path
		end

		def start_recording(id, url)
			return if currently_recording.has_key? id
			Thread.new { download_to_tmp_path(url) }
		end

		def end_recording(id)
			return if not currently_recording.has_key? id
		end


  end
end
