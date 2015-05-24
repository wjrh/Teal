module Teal
  class App < Sinatra::Base

	# route to get all djs
    get '/djs' do
    	content_type :json
    	Dj.select(:id, :dj_name).all.to_json
    end
  	
  end
end