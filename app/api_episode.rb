module Teal
	class App < Sinatra::Base

		# method to handle episodes by id
		# we attach program shortname and name to the end of the episode
		# TODO: might want to find a more elegant solution to adding shortname and program name
		get "/episodes/:id/?" do
			episode = Episode.find(params['id'])
			halt 404 if episode == nil
			episode["program_shortname"] = episode.program.shortname
			episode["program_name"] = episode.program.name
			return episode.to_json(:only => [:program_shortname, :program_name])
		end
		
		# route to update episodes
		# returns 404 if the episode doesn't exist
		# returns 401 if the program of the episode is not owned by the current user
		post "/episodes/:id/?" do
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details
			data = JSON.parse body

			episode = Episode.find(params['id'])
			halt 404 if episode == nil

			#check for ownership
			halt 401, "not allowed to perform such action" if not owner?(episode.program)

			episode.update_attributes(data)

			return episode.to_json
		end

		# post a new episode
		# to create a new episode, you need to post it to a place with the shortname
		post "/programs/:shortname/episodes/?" do
			data = JSON.parse body
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details

			program = Program.where(shortname: params['shortname']).first
			newepisode = Episode.new(data)
			newepisode.save
			program.episodes.push(newepisode)
			program.save

			return newepisode.to_json
		end

		# post a new episode (the shortname is defined in the url)
		# this method is alternative to the post in the url way
		# /episodes?shortname=xyxyxy is the kind of route being given
		post "/episodes/?" do 
			halt 400 if !params['shortname'] or params['shortname'].eql?("")
			
			data = JSON.parse body
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details

			program = Program.where(shortname: params['shortname']).first
			newepisode = Episode.new(data)
			newepisode.save
			program.episodes.push(newepisode)
			program.save

			return newepisode.to_json	
		end

		# delete the episode
		#returns an error if the user is not an owner
		delete "/episodes/:id/?" do
			episode = Episode.find(params['id'])
			if owner?(episode.program)
				return episode.destroy
			else
				halt 401, "not allowed to perform such action"
			end
		end


	end
end
