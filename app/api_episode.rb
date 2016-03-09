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

			# episode = Episode.find(params['shortname'])
			# halt 400 if episode == nil

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
				episode.to_json(sdetailed: true)
			else
				halt 401, "not allowed to perform such action"
			end
		end



		# private

		# # to include the episodes as well, add it to options
	

	 # 	def return_epsiode_selectively(episode, options = {})
	 # 		# unless episode.program.owner?(current_user)
	 # 		#  return {}.to_json if episode.pubdate.past?
	 # 		# end

 	# 	 	 filter = {:only => [:name, :description, :image, :pubdate, :start_time,
 	# 	 	 									:end_time, :guid, :length, :type, :program_shortname, :program_name],
 	#  								:include => []}
 	#  		 if episode.audio_url
		# 			filter[:include].push(:audio_url)
		# 	 end
		# 	 episode["program_shortname"] = episode.program.shortname
		# 	 episode["program_name"] = episode.program.name
		# 	 episode["id"] = episode.id
		# 	 options = options.merge(filter)
 	# 	   episode.to_json(options)
 	# 	end


	end
end
