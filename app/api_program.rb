module Teal
	class App < Sinatra::Base

		# Return the list of all programs
		# TODO(renandincer): this will in the future return only the programs owned
		get "/programs/?" do
			return Program.get_all.to_json if current_user === "renandincer@gmail.com"
			Program.where(:owners => current_user).all.to_json
		end

		# get info about a specific program
		# returns 404 if the program requested cannot be found
		# if program is found returns episodes in a sorted manner
		# TODO: we might be paying some performance penalty when sorting. Look into that.
		get "/programs/:shortname/?" do
			program = Program.where(:shortname => params['shortname']).first
			halt 404 if program.nil?
			program.to_json(:detailed => true)
		end

		# method to post a new program
		# method checks for the presence of a shortname
		# and if it doesn't exist, creates a new one from the name
		# after initializing if the program is new, the owner is set to the current user
		post "/programs/:shortname?/?" do
			request.body.rewind
			body =  request.body.read
			data = JSON.parse body
			halt 400 if data['name'].nil? or data['name'].eql?("")
			
			# if the shortname is not provded, provide one
			if !data["shortname"] or data["shortname"].eql?("")
				shortname = data["name"].downcase.gsub(/[^0-9A-Za-z]/, '-')
				data.merge!(shortname: shortname)
			end
			
			#get the program
			#prevent new program creation when a program is changing shortnames. this is why we need ids.
			program = Program.where(id: data['id']).first || Program.where(shortname: params["shortname"]).first_or_initialize
			
			#if the program doesn't exist make the user an owner and save
			if program.new_record?
				halt 400, "you need log in to enter a new program".to_json if not authenticated?
				program.update_attributes(data)
				program.push(owners: current_user)
				program.save
				program.to_json
			elsif program.owner?(current_user)
				program.update_attributes(data)
				program.save
				program.to_json
			else
				halt 401, "not allowed to perform such action"
			end
		end


		# delete the program with the shortname provided.
		# returns an error if the user is not an owner
		# returns the destroyed program when returned
		# TODO: mongo will return an error when deleting a program with episodes, handle that
		delete "/programs/:shortname/?" do
			program = Program.where(shortname: params['shortname']).first
			if program.owner?(current_user)
				program.destroy
				program.to_json
			else
				halt 401, "not allowed to perform such action"
			end
		end


	end
end
