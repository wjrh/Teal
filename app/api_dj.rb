module Teal
  class App < Sinatra::Base

	# get djs - list all djs
    get '/djs' do
    	content_type :json
      halt 404 if Dj.count == 0 #halt if any dj doesn't exist
      Dj.select(:id, :dj_name, :description).all.to_json
    end
  	
    # post a new Dj
    post "/djs" do
      request.body.rewind  # in case someone already read it
      data = JSON.parse request.body.read
      dj = Dj.new(dj_params(data))

      if dj.save
        status 200
      else
        content_type :json
        halt 400, 'This DJ could not be saved. Please fill all necessary fields.'
      end
    end

    # get info about a specific dj id
    get "/djs/:id" do
      content_type :json
      dj = Dj.find_by_id(params['id'])
      halt 404 if dj.nil? #halt if dj doesn't exist
      dj.to_json(:only => [ :id, :dj_name, :description ])
    end

    # update info for an existing dj
    put "/djs/:id" do
      request.body.rewind
      data = JSON.parse request.body.read
      dj = Dj.find_by_id(params['id'])

      halt 404 if dj.nil? #halt if show doesn't exist

      update = dj_params(data)

      if dj.update(update)
        status 200
      else
        content_type :json
        halt 400, 'This show could not be saved.'
      end
    end

  	# delete :id - delete dj
    delete "/djs/:id" do
      dj = Dj.where(id: params['id']).first
      halt 404 if dj.nil? #halt if show doesn't exist
      if dj.destroy
        status 200
      else
        content_type :json
        halt 400, 'This show could not be deleted.'
      end
    end

  	# get dj/shows - list all shows of the dj
  	# get dj/episodes - list latest episodes of the dj

    def dj_params (data)
      hash = {
        :net_id => data["net_id"],
        :email => data["email"],
        :dj_name => data["dj_name"],
        :real_name => data["real_name"],
        :description => data["description"]
      }
      return hash
    end


  end
end