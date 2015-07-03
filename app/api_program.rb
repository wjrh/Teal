module Teal
  class App < Sinatra::Base

    # get list of all programs
  	get "/programs" do
  		content_type :json
      halt 404 if Program.count == 0 #halt if program doesn't exist
      programs = []
      Program.find_each do |program|
        programs << {
          :id => program.id,
          :title => program.title,
          :description => program.description,
          :creator_ids => program.creator_ids
        }
      end
      programs.to_json
  	end

    # post a new program
  	post "/programs" do
  		request.body.rewind  # in case someone already read it
  		data = JSON.parse request.body.read

  		program = Program.new(program_params(data))

  		if program.save
  			status 200
  		else
  			content_type :json
  			halt 400, 'This program could not be saved. Please fill all necessary fields.'
  		end
  	end

    # get info about a specific program, this in the future will provide specific links
  	get "/programs/:id" do
  		content_type :json
  		program = Program.find_by_id(params['id'])
      halt 404 if program.nil? #halt if program doesn't exist
  		program.to_json(:only => [ :id, :title, :description, :creator_ids ])
  	end

    # update program
  	put "/programs/:id" do
  		request.body.rewind
  		data = JSON.parse request.body.read
  		program = Program.find_by_id(params['id'])

  		halt 404 if program.nil? #halt if program doesn't exist

  		update = program_params(data)

  		if program.update(update)
  			status 200
  		else
  			content_type :json
  			halt 400, 'This program could not be saved.'
  		end
  	end

    # delete a program with id
    delete "/programs/:id" do
      program = Program.find_by_id(params['id'])
      halt 404 if program.nil? #halt if program doesn't exist
      if program.destroy
        status 200
      else
        content_type :json
        halt 400, 'This program could not be deleted.'
      end
    end

    # helper method for parameters
    def program_params(data)

      data["creators"].to_a.each do |creator|
        halt 400, "Creator #{creator} does not exist" unless Creator.exists?(creator)
      end

      hash = {
        :title => data["title"],
        :description => data["description"],
        :image => data["image"],
        :creator_ids => data["creators"].to_a #match creator ids with creators
      }
      return hash
    end



  end
end
