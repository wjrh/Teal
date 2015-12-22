# Create = PUT with a new URI
#          POST to a base URI returning a newly created URI
# Read   = GET
# Update = PUT with an existing URI
# Delete = DELETE


module Teal
	class App < Sinatra::Base

		# get list of all programs
		get "/programs/?" do
			allPrograms = Program.all
			if allPrograms.empty?
				return [].to_json
			end
			return allPrograms.to_json(:only => [:name, :shortname, :times, :image, :description, :subtitle, :categories, :creators])
		end


		# get info about a specific program
		# TODO(renandincer): list episodes
		# TODO(renandincer): list media
		get "/programs/:shortname/?" do
			program = Program.first(:shortname => params['shortname'])
			halt 404 if program.nil?
			program.episodes.sort! { |a,b| a.pubdate <=> b.pubdate }
			return program.to_json(
								:except => [:program_id],
								:include => [:episodes]
								)
		end

		# post a new program
		post "/programs/:shortname?/?" do
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details
			data = JSON.parse body

			halt 400 if data['name'].nil?

			# if the shortname is not provded, provide one
			if !data["shortname"] or data["shortname"].eql?("")
				shortname = data["name"].downcase.gsub(/[^0-9A-Za-z]/, '-')
				data.merge!(shortname: shortname)
			end

			program = Program.find_or_initialize_by_shortname(params['shortname'])
			program.update_attributes(data)
			return program.to_json
		end

		# Update if PUT with an existing URI creates if PUT with a new URI,
		# put "/programs/:shortname/?" do
		# 	request.body.rewind  # in case someone already read it
		# 	body =  request.body.read # data here will contain a JSON document with necessary details
		# 	data = JSON.parse body

		# 	program = Program.find_or_initialize_by_shortname(params['shortname'])
		# 	program.update_attributes(data)
		# 	return program.to_json
		# end


		# get list of all programs
		delete "/programs/:shortname/?" do
			return Program.destroy_all(:shortname => params['shortname'])
		end

	end
end
