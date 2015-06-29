module Teal
  class App < Sinatra::Base

	# get creators - list all creators
    get '/creators' do
    	content_type :json
      halt 404 if Creator.count == 0 #halt if any creator doesn't exist
      Creator.select(:id, :creator_name, :description).all.to_json
    end
  	
    # post a new Creator
    post "/creators" do
      request.body.rewind  # in case someone already read it
      data = JSON.parse request.body.read
      creator = Creator.new(creator_params(data))

      if creator.save
        status 200
      else
        content_type :json
        halt 400, 'This DJ could not be saved. Please fill all necessary fields.'
      end
    end

    # get info about a specific creator id
    get "/creators/:id" do
      content_type :json
      creator = Creator.find_by_id(params['id'])
      halt 404 if creator.nil? #halt if creator doesn't exist
      creator.to_json(:only => [ :id, :creator_name, :description ])
    end

    # update info for an existing creator
    put "/creators/:id" do
      request.body.rewind
      data = JSON.parse request.body.read
      creator = Creator.find_by_id(params['id'])

      halt 404 if creator.nil? #halt if show doesn't exist

      update = creator_params(data)

      if creator.update(update)
        status 200
      else
        content_type :json
        halt 400, 'This show could not be saved.'
      end
    end

  	# delete :id - delete creator
    delete "/creators/:id" do
      creator = Creator.where(id: params['id']).first
      halt 404 if creator.nil? #halt if show doesn't exist
      if creator.destroy
        status 200
      else
        content_type :json
        halt 400, 'This show could not be deleted.'
      end
    end

  	# get creator/shows - list all shows of the creator
  	# get creator/episodes - list latest episodes of the creator

    def creator_params(data)
      hash = {
        :net_id => data["net_id"],
        :email => data["email"],
        :creator_name => data["creator_name"],
        :real_name => data["real_name"],
        :description => data["description"]
      }
      return hash
    end


  end
end