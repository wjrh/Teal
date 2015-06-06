module Teal
  class App < Sinatra::Base

  	get "/shows" do
  		content_type :json
      halt 404 if Show.count == 0 #halt if show doesn't exist
    	Show.select(:id, :title, :description).all.to_json
  	end

  	post "/shows" do
  		request.body.rewind  # in case someone already read it
  		data = JSON.parse request.body.read
  		show = Show.new(:title => data["title"], :description => data["description"])

  		if show.save
  			status 200
  		else
  			content_type :json
  			halt 400, 'This show could not be saved. Please fill all necessary fields.'
  		end
  	end

  	get "/shows/:id" do
  		content_type :json
  		show = Show.where(id: params['id']).select(:id, :title, :description).first
      halt 404 if show.nil? #halt if show doesn't exist
  		show.to_json
  	end

  	put "/shows/:id" do
  		request.body.rewind
  		data = JSON.parse request.body.read
  		show = Show.where(id: params['id']).first

  		halt 404 if show.nil? #halt if show doesn't exist

  		update = {:title => data["title"], :description => data["description"]}

  		if show.update(update)
  			status 200
  		else
  			content_type :json
  			halt 400, 'This show could not be saved.'
  		end
  	end

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
  end
end
