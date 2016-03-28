module Teal
	class App < Sinatra::Base

		# method to list tracks
		get "/episodes/:id/tracks/?" do
			begin
				episode = Episode.find(params['id'])
			rescue Mongoid::Errors::DocumentNotFound
				halt 400, "this episode does not exist"
			end

			episode.tracks.to_json
		end

		# method to post a track
		post "/episodes/:id/tracks/?:track_id?" do
			halt 400, "you need to log in to enter a new track".to_json if not authenticated?
			request.body.rewind
			body = request.body.read
			data = JSON.parse body

			begin
				episode = Episode.find(params['id'])
			rescue Mongoid::Errors::DocumentNotFound
				halt 400, "this episode does not exist"
			end
			
			halt 401, "not allowed to perform such action" if not episode.program.owner?(current_user)
			
			if params["track_id"] #if the track already exists
				begin
					track = episode.tracks.where(id: params["track_id"]).first
				rescue Mongoid::Errors::DocumentNotFound
					halt 400, "this track does not exist"
				end
				track.update_attributes(data)
				episode.save
				return track.to_json
			else
				newtrack = Track.new(data)
				episode.tracks << newtrack
				episode.save
				return newtrack.to_json
			end
		end

		# method to post a track
		post "/episodes/:id/tracks/:track_id/log" do
			halt 400, "you need to log in to enter a new track".to_json if not authenticated?
			request.body.rewind
			body = request.body.read
			data = JSON.parse body

			begin
				episode = Episode.find(params['id'])
			rescue Mongoid::Errors::DocumentNotFound
				halt 400, "this episode does not exist"
			end
			
			halt 401, "not allowed to perform such action" if not episode.program.owner?(current_user)
			if params["track_id"] #if the track exists
				begin
					track = episode.tracks.where(id: params["track_id"]).first
				rescue Mongoid::Errors::DocumentNotFound
					halt 400, "this track does not exist"
				end
				track.log_time = Time.now + episode.delay
				episode.save

				uri = URI("http://nginx/programs/#{episode.program.shortname}/live/publish")
	      http = Net::HTTP.new(uri.host, uri.port)
	      request = Net::HTTP::Post.new(uri.request_uri)
	      request.body = {:type => "track-log", :track => track, :epsiode => episode}.to_json
	      response = http.request(request)

				return track.to_json
			else
				halt 400, "a track needs to be specified"
			end

			

		end

		#method to delete a track
		delete "/episodes/:id/tracks/?:track_id?" do
			halt 400, "you need to log in to enter a new track".to_json if not authenticated?
			begin
				episode = Episode.find(params['id'])
			rescue Mongoid::Errors::DocumentNotFound
				halt 400, "this episode does not exist"
			end
			halt 401, "not allowed to perform such action" if not episode.program.owner?(current_user)
			if params["track_id"] #if the track exists
				begin
					track = episode.tracks.where(id: params["track_id"]).first
				rescue Mongoid::Errors::DocumentNotFound
					halt 400, "this track does not exist"
				end
				track.destroy
				episode.save
				return track.to_json
			else
				halt 400, "a track needs to be specified"
			end
		end


	end
end
