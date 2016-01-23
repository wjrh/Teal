# Create = PUT with a new URI
#          POST to a base URI returning a newly created URI
# Read   = GET
# Update = PUT with an existing URI
# Delete = DELETE


module Teal
	class App < Sinatra::Base

		# get list of all programs
		get "/programs/?" do
			return Program.get_all.to_json
		end


		# get info about a specific program
		get "/programs/:shortname/?" do
			program = Program.first(:shortname => params['shortname'])
			halt 404 if program.nil?

			#sort by pubdate
			program.episodes.sort! { |a,b| a.pubdate <=> b.pubdate }
			return program.to_json_with_episodes
		end

		# post a new program
		post "/programs/:shortname?/?" do
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document
			data = JSON.parse body

			#TODO(renandincer): check if the sent document is of type program

			halt 400 if data['shortname'].nil?

			# if the shortname is not provded, provide one
			if !data["shortname"] or data["shortname"].eql?("")
				shortname = data["name"].downcase.gsub(/[^0-9A-Za-z]/, '-')
				data.merge!(shortname: shortname)
			end
			
			program = Program.first(:shortname => params["shortname"])
			
			#if the program doesn't exist, create it and make the user an owner
			if program.nil?
				program = Program.initialize_by_shortname(params['shortname'])
				program.owners.insert(current_user)
				program.update_attributes(data)
				return program.to_json
			#else the program exists, check for owner before going forward
			elsif not owner?(program)
					halt 401, "not allowed to perform such action"
			else
					program.update_attributes(data)
					return program.to_json
			end
		end

		delete "/programs/:shortname/?" do
			program = Program.first(:shortname => params['shortname'])
			if owner?(program)
				return program.destroy
			else
				halt 401, "not allowed to perform such action"
			end
		end

	end
end
