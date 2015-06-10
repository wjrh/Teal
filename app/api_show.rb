module Teal
  class App < Sinatra::Base

    # get list of all shows
  	get "/shows" do
  		content_type :json
      halt 404 if Show.count == 0 #halt if show doesn't exist
    	Show.select(:id, :title, :description).all.to_json
  	end

    # post a new show
  	post "/shows" do
  		request.body.rewind  # in case someone already read it
  		data = JSON.parse request.body.read
  		show = Show.new(show_params(data))

  		if show.save
  			status 200
  		else
  			content_type :json
  			halt 400, 'This show could not be saved. Please fill all necessary fields.'
  		end
  	end

    # get info about a specific show, this in the future will provide specific links
  	get "/shows/:id" do
  		content_type :json
  		show = Show.find_by_id(params['id'])
      halt 404 if show.nil? #halt if show doesn't exist
  		show.to_json(:only => [ :id, :title, :description ])
  	end

    # update show
  	put "/shows/:id" do
  		request.body.rewind
  		data = JSON.parse request.body.read
  		show = Show.find_by_id(params['id'])

  		halt 404 if show.nil? #halt if show doesn't exist

  		update = show_params(data)

  		if show.update(update)
  			status 200
  		else
  			content_type :json
  			halt 400, 'This show could not be saved.'
  		end
  	end

    # delete a show with id
    delete "/shows/:id" do
      show = Show.where(id: params['id']).first
      halt 404 if show.nil? #halt if show doesn't exist
      if show.destroy
        status 200
      else
        content_type :json
        halt 400, 'This show could not be deleted.'
      end
    end

    # helper method for parameters
    def show_params(data)
      hash = {
        :title => data["title"],
        :description => data["description"]
      }
      return hash
    end



  end
end
