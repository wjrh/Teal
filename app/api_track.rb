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
		post "/episodes/:id/tracks/:track_id?/?" do
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
			
			if params["track_id"]
				track = episode.tracks.where(id: params["id"]).first
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


		# method to delete a track
	end
end
