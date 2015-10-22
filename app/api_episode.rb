# Create = PUT with a new URI
#          POST to a base URI returning a newly created URI
# Read   = GET
# Update = PUT with an existing URI
# Delete = DELETE


module Teal
	class App < Sinatra::Base

		# get info about an episode
		get "/episodes/:id/?" do
			episode = Episode.find(params['id'])
			return episode.to_json(:only => [:id, :name, :description, :image])
		end

		# post a new episode
		post "/programs/:shortname/episodes/?" do
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details
			data = JSON.parse body

			newepisode = Episode.new(data)
			newepisode.save

			program = Program.first(:shortname => params['shortname'])
			program.episodes << newepisode
			program.save

			return newepisode.to_json
		end

		# Update if PUT with an existing URI creates if PUT with a new URI,
		put "/episodes/:id/?" do
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details
			data = JSON.parse body

			episode = Episode.find(params['id'])
			program.update_attributes(data)
			return program.to_json
		end

		delete "/episodes/:id/?" do
			Episode.destroy(params['id'])
			return 200
		end


	end
end
