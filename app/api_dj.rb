module Teal
  class App < Sinatra::Base

	# get djs - list all djs
    get '/djs' do
    	content_type :json
    	Dj.select(:id, :dj_name).all.to_json
    end
  	
  	# post djs - create new dj
  	# get djs:id - get info about a dj
  	# put:id - update dj
  	# delete :id - delete dj

  	# get dj/shows - list all shows of the dj
  	# get dj/episodes - list latest episodes of the dj


  end
end