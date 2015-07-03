require_relative 'spec_helper'

describe 'Creator API' do

  # get creators - list all creators
  describe 'GET /creators' do
    it 'is not successful if empty' do
      get '/creators'
      expect(last_response.status).to eq 404
    end

    it 'is successful' do
      create(:creator)
      get '/creators'
      expect(last_response.status).to eq 200
    end
  end

  describe 'Creator' do
    it 'gets created with a email' do
      creator = Creator.new
      creator.email = "jamesd@lafayette.edu"
      creator.save
    end

    it 'can have a description' do
      creator = Creator.new
      creator.description = "I'm a bad DJ"
      creator.save
    end
  end

  # post creator
  describe 'POST /creators' do
    let(:body) { attributes_for(:creator).to_json }
    before do
      post '/creators', body, { "CONTENT_TYPE" => "application/json" }
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'has one creator' do
      expect(Creator.count).to eq 1
    end

    it 'responds with 404 if email not included' do
      post '/creators', {:foo => "bar"}.to_json, { "CONTENT_TYPE" => "application/json" }
      expect(last_response.status).to eq 400
    end
  end

  # get creator details
  describe 'GET /creators/:id' do
    let(:check) {Creator.second.id}
    before do
      create(:creator)
      second_creator = create(:creator)
      100.times do
        create(:creator)
      end
      get "/creators/#{check}"
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'returns 1 creator' do
      response = MultiJson.load(last_response.body)
      expect(response.size).to eq 4 #id, title, description, programs
    end

    it "fails if creator doesn't exist" do
      get('/creators/23232322')
      expect(last_response.status).to eq 404
    end
  end


  # update creator
  describe 'PUT /creators/:id' do
    let(:body) { attributes_for(:creator, email: "updatedtitle@gogo.xxx").to_json }
    let(:check) {Creator.second.id}
    before do
      100.times do
        create(:creator)
      end
      put("/creators/#{check}", body)
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it "is updated" do
      @creator = Creator.find(check)
      expect(@creator.email).to eq "updatedtitle@gogo.xxx"
    end

    it "fails if creator doesn't exist" do
      put('/creators/23232322', body)
      expect(last_response.status).to eq 404
    end
  end

  # delete creator
  describe 'DELETE /creators/:id' do
    before do
      100.times do
        create(:creator)
      end

    end

    it 'is successful' do
      check = Creator.second.id
      delete "/creators/#{check}"
      expect(last_response.status).to eq 200
    end

    it 'does not respond the second time' do
      check = Creator.second.id
      delete "/creators/#{check}"
      delete "/creators/#{check}"
      expect(last_response.status).to eq 404
    end
  end



  describe 'add programs to creators'
end




