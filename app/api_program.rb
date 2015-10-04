module Teal
	class App < Sinatra::Base

		# get list of all programs
		get "/programs/?" do
			return Program.listAll.to_json
		end

		# post a new program
		post "/programs/?" do
			request.body.rewind  # in case someone already read it
			data = JSON.parse request.body.read # data here will contain a JSON document with necessary details
			if Program.add(data)
				return status 200, {"success": "saved"}.to_json
			else
				return halt 400, {"error": "could not be saved"}.to_json
			end
		end

		# get info about a specific program, this in the future will provide specific links
		get "/programs/:shortname/?" do
			program = Program.find(params['shortname'])
			if program
				return program
			else 
				halt 404, {"error": "could not be found"}.to_json
			end
		end


	end
end