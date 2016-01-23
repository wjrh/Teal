# Create = PUT with a new URI
#          POST to a base URI returning a newly created URI
# Read   = GET
# Update = PUT with an existing URI
# Delete = DELETE


module Teal
	class App < Sinatra::Base

		get "/episodes/:id/?" do
			episode = Episode.find(params['id'])
			halt 404 if episode == nil
			episode["program_shortname"] = episode.program.shortname
			episode["program_name"] = episode.program.name
			return episode.to_json(
								:except => [:owners, :program_id, :created_at, :updated_at, :guid]
								)								
		end

		post "/episodes/:id/?" do
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details
			data = JSON.parse body

			episode = Episode.find(params['id'])
			halt 404 if episode == nil

			episode.update_attributes(data)

			return episode.to_json(
								:except => [:program_id, :created_at, :updated_at, :guid]
								)
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

			return newepisode.to_json(
								:except => [:program_id, :created_at, :updated_at, :guid]
								)
		end

		# post a new episode (the shortname is defined in the url)
		post "/episodes/?" do #GET /episodes?shortname=vbb
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details
			data = JSON.parse body

			halt 400 if !params['shortname'] or params['shortname'].eql?("")

			newepisode = Episode.new(data)
			newepisode.save

			program = Program.first(:shortname => params['shortname'])
			program.episodes << newepisode
			program.save

			return newepisode.to_json(
								:except => [:program_id, :created_at, :updated_at, :guid]
								)
		end



		# Update if PUT with an existing URI creates if PUT with a new URI,
		# put "/episodes/:id/?" do
		# 	request.body.rewind  # in case someone already read it
		# 	body =  request.body.read # data here will contain a JSON document with necessary details
		# 	data = JSON.parse body

		# 	episode = Episode.find(params['id'])
		# 	program.update_attributes(data)
		# 	return program.to_json
		# end


		delete "/episodes/:id/?" do
			Episode.destroy(params['id'])
			return 200
		end


	end
end
