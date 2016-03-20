module Teal
	class App < Sinatra::Base

		# respond to regex'd episode file request
		# captures something like this:
		# /episodes/507f191e810c19729de860ea.mp3
		get "/download/:id.?:format?" do
			episode_id = params['id']
			episode = Episode.find(episode_id)
			halt 404, "episode not found" if not episode
	
			path_to_file = File.join(Teal.config.media_path,"processed", "#{episode_id}.mp3")
			halt 500, "episode not found internally" if not File.exists?(path_to_file)

			#log request
			p "TIME=#{Time.new.utc} FILE=#{episode_id}.mp3 IP=#{request.ip} HTTP_RANGE=#{request.env["HTTP_RANGE"]}"

			content_type episode.type
			send_file path_to_file
		end
	end
end



