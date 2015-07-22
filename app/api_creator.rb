module Teal
  class App < Sinatra::Base

	# get creators - list all creators
    get '/creators/?' do
    	content_type :json
      halt 404 if Creator.count == 0 #halt if any creator doesn't exist
      Creator.select(:id, :name, :image_url).all.to_json
    end
  	
    # post a new Creator
    post "/creators/?" do
      request.body.rewind  # in case someone already read it
      data = JSON.parse request.body.read
      creator = Creator.new(creator_params(data))

      if creator.save
        return creator.to_json
      else
        halt 400, 'This DJ could not be saved. Please fill all necessary fields.'
      end
    end

    # get info about a specific creator id
    get "/creators/:id/?" do
      content_type :json
      creator = Creator.find_by_id(params['id'])
      halt 404 if creator.nil? #halt if creator doesn't exist
      return {
        :id => creator.id,
        :name => creator.name,
        :description => creator.description,
        :programs => creator.programs.select(:id, :title)
      }.to_json
    end

    # update info for an existing creator
    put "/creators/:id/?" do
      request.body.rewind
      data = JSON.parse request.body.read
      creator = Creator.find_by_id(params['id'])

      halt 404 if creator.nil? #halt if program doesn't exist

      update = creator_params(data)

      if creator.update(update)
        return creator.to_json
      else
        content_type :json
        halt 400, 'This dj could not be saved.'
      end
    end

  	# delete :id - delete creator
    delete "/creators/:id/?" do
      creator = Creator.where(id: params['id']).first
      halt 404 if creator.nil? #halt if program doesn't exist
      if creator.destroy
        status 200
      else
        content_type :json
        halt 400, 'This dj could not be deleted.'
      end
    end

  	# get creator/programs - list all programs of the creator
  	# get creator/episodes - list latest episodes of the creator

    def creator_params(data)
      hash = {
        :lafayetteid => data["lafayetteid"],
        :email => data["email"],
        :name => data["name"],
        :real_name => data["real_name"],
        :image_url => data["image_url"],
        :description => data["description"]
      }
      return hash
    end


  end
end