require_relative 'spec_helper'
 
describe 'Show Api' do
  describe 'GET /shows' do
    before { get '/shows' }
 
    it 'is successful' do
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST /shows' do
    before { post '/shows' }
 
    it 'is successful' do
      expect(last_response.status).to eq 200
    end
  end

end



  	# get shows - list all shows
  	# post shows w/dj params - create new show with djs
  	# get show:id - get info about a show
  	# put show:id - update show
  	# delete :show - delete show