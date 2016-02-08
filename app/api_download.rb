module Teal
	class App < Sinatra::Base

		# respond to regex'd episode file request
		# captures something like this:
		# /episodes/507f191e810c19729de860ea.mp3
		get /\/episodes\/(([\w])+).mp3/ do
			episode_id = params['captures'].first
			halt 404, "episode not found" if not Episode.find(episode_id).exists?
		
			path_to_file = File.join(Teal.config.media_path,"processed", "#{episode_id}.mp3")
			halt 500, "episode not found internally" if not File.exists?(path_to_file)

			#log request
			p "TIME=#{Time.new.utc} 
				FILE=#{episode_id}.mp3 
				IP=#{request.ip} 
				HTTP_RANGE=#{request["HTTP_RANGE"]}"

			send_file path_to_file
		end
	end
end



