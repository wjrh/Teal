require_relative 'spec_helper'
 
describe 'Show API' do

  # get shows - list all shows
  describe 'GET /shows' do
    before { get '/shows' }
 
    it 'is successful' do
      expect(last_response.status).to eq 200
    end
  end

  # post shows w/dj params - create new show with djs
  describe 'POST /shows' do
    before do
      post('/shows',
        MultiJson.dump(attributes_for(:user), pretty: true),
        { "CONTENT_TYPE" => "application/json" })
    end
 
    it 'is successful' do
      expect(last_response.status).to eq 200
    end
  end

  # get show:id - get info about a show
  describe 'GET /shows/1' do
    before do
      100.times do
        create(:show)
      end
      get '/shows/1'
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'returns 1 show' do
      response = MultiJson.load(last_response.body)
      expect(response).size.to eq 1
    end
  end

end



# get shows - list all shows
# post shows w/dj params - create new show with djs
# get show:id - get info about a show
# put show:id - update show
# delete :show - delete show