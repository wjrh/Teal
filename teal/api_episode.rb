require 'uri'
require "net/http"

module Teal
	class App < Sinatra::Base

		# method to handle episodes by id
		# we attach program shortname and name to the end of the episode
		# TODO: might want to find a more elegant solution to adding shortname and program name
		get "/episodes/:id/?" do
			begin
				episode = Episode.find(params['id'])
			rescue Mongoid::Errors::DocumentNotFound
				halt 400, "this episode does not exist"
			end
			episode.to_json(detailed: true)
		end
		
		# route to update episodes
		# returns 404 if the episode doesn't exist
		# returns 401 if the program of the episode is not owned by the current user
		post "/episodes/:id/?" do
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details
			data = JSON.parse body

			halt 400, "this episode does not exist" if not Episode.where(id: params["id"]).exists?
			episode = Episode.find(params['id'])
			halt 404 if episode == nil

			#check for ownership
			halt 400, "you need log in to enter a new program".to_json if not authenticated?
			halt 401, "not allowed to perform such action" if not episode.program.owner?(current_user)

			episode.update_attributes(data)
			episode.to_json(detailed: true)
		end

		# post a new episode
		post "/programs/:shortname/episodes/?" do
			newepisode
		end

		# post a new episode (the shortname is defined in the url)
		# this method is alternative to the post in the url way
		# /episodes?shortname=xyxyxy is the kind of route being given
		post "/episodes/?" do 
			newepisode
		end

		def newepisode
			halt 400 if !params['shortname'] or params['shortname'].eql?("")
			halt 400, "you need log in to enter a new program".to_json if not authenticated?
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details
			data = JSON.parse body
			program = Program.where(shortname: params['shortname']).first
			halt 401, "not allowed to perform such action" if not program.owner?(current_user)
			newepisode = Episode.new(data)
			newepisode.save
			program.episodes << newepisode
			program.save
			newepisode.to_json(detailed: true)
		end

		# delete the episode
		#returns an error if the user is not an owner
		delete "/episodes/:id/?" do
			episode = Episode.find(params['id'])
			if episode.program.owner?(current_user)
				episode.destroy
				path_to_file = File.join(Teal.config.media_path,"processed", "#{episode.id}.mp3")
				File.delete(path_to_file) if File.exist?(path_to_file)
				episode.to_json(detailed: true)
			else
				halt 401, "not allowed to perform such action"
			end
		end

		#start recording
		post "/episodes/:id/start" do
			halt 400, "you need log in to start recording".to_json if not authenticated?
			episode = Episode.find(params['id'])
			halt 401, "not allowed to perform such action" if not episode.program.owner?(current_user)
			stream = episode.program.stream
			halt 400, "this episode does not exist" if episode.nil?
			halt 400, "this program does not have a valid stream" if not stream =~ /\A#{URI::regexp(['http', 'https'])}\z/
			halt 400, "the stream of this program is not reachable" if not url_exist?(stream)
			uri = URI.parse("http://recorder/start-recording")
			response = Net::HTTP.post_form(uri, {'episode_id' => params['id'],
																						 'user_key' => getKey(current_user),
																						 'stream_url' => episode.program.stream,
																						 'delay' => params['delay'] | 12
																						 })
			halt 500, "recorder could not be started" if (response.code.to_i != 200)
			episode.delay = params['delay'].to_i | 12
			episode.start_time = Time.now + episode.delay
			episode.save

      Live.publish( {:type => "episode-start", :episode => episode }, episode.program, episode.delay)

			200
		end

		#stop recording
		post "/episodes/:id/stop" do
			halt 400, "you need log in to stop recording".to_json if not authenticated?
			episode = Episode.find(params['id'])
			halt 401, "not allowed to perform such action" if not episode.program.owner?(current_user)
			halt 400, "this episode does not exist" if episode.nil?
			uri = URI.parse("http://recorder/end-recording")
			response = Net::HTTP.post_form(uri, {'episode_id' => params['id']})
			p "RESPONSE FROM STOP RECORDER IS #{response.code}"
			halt 500, "recorder could not be stopped" if (response.code.to_i != 200)
			episode.end_time = Time.now + episode.delay #delay
			episode.save

      Live.publish( {:type => "episode-end", :episode => episode }, episode.program, 0)

			200
		end


		private
		def url_exist?(url_string)
			#RETURN TRUE ALL THE TIME FOR NOW
			return true
		  url = URI.parse(url_string)
		  req = Net::HTTP.new(url.host, url.port)
		  req.use_ssl = (url.scheme == 'https')
		  path = url.path if url.path.present?
		  res = req.request_head(path || '/')
		  p res.code
		  if res.kind_of?(Net::HTTPRedirection)
		    url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL 
		  else
		    ! %W(4 5).include?(res.code[0]) # Not from 4xx or 5xx families
		  end
		rescue Errno::ENOENT
		  false #false if can't find the server
		end

	end
end
