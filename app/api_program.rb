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
			return allPrograms.to_json(:only => [:name, :shortname, :description, :image, :subtitle])
		end

		# post a new program
		post "/programs/?" do
			request.body.rewind  # in case someone already read it
			body =  request.body.read # data here will contain a JSON document with necessary details
			data = JSON.parse body

			# if the shortname is not provded, provide one
			if !data["shortname"]
				shortname = data["name"].downcase.gsub(/[^0-9A-Za-z]/, '-')
				data.merge!(shortname: shortname)
			end

			newprogram = Program.new(data)
			newprogram.save
			return newprogram.to_json
		end


		# get info about a specific program, this in the future will provide specific links
		get "/programs/:shortname/?" do
			Program.first(:shortname => params['shortname'])
		end

	end
end
