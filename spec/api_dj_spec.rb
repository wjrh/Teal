require_relative 'spec_helper'

describe 'Dj API' do

  # get djs - list all djs
  describe 'GET /djs' do
    it 'is not successful if empty' do
      get '/djs'
      expect(last_response.status).to eq 404
    end

    it 'is successful' do
      create(:dj)
      get '/djs'
      expect(last_response.status).to eq 200
    end
  end

  describe 'Dj' do
    it 'gets created with a email' do
      dj = Dj.new
      dj.email = "jamesd@lafayette.edu"
      dj.save
    end

    it 'can have a description' do
      dj = Dj.new
      dj.description = "I'm a bad DJ"
      dj.save
    end
  end

  # post dj
  describe 'POST /djs' do
    let(:body) { { :email => "coconutututu@mango.edu" }.to_json }
    before do
      post '/djs', body, { "CONTENT_TYPE" => "application/json" }
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'has one dj' do
      expect(Djs.count).to eq 1
    end

    it 'responds with 404 if email not included' do
      post '/djs', {:foo => "bar"}.to_json, { "CONTENT_TYPE" => "application/json" }
      expect(last_response.status).to eq 400
    end
  end

  # get dj details
  describe 'GET /djs/:id' do
    let(:check) {Djs.second.id}
    before do
      create(:dj)
      second_dj = create(:dj)
      100.times do
        create(:dj)
      end
      get "/djs/#{check}"
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'returns 1 dj' do
      response = MultiJson.load(last_response.body)
      expect(response.size).to eq 3 #id, title and description
    end

    it "fails if dj doesn't exist" do
      get('/djs/23232322')
      expect(last_response.status).to eq 404
    end
  end


  # update dj
  describe 'PUT /djs/:id' do
    let(:body) { attributes_for(:dj, email: "updatedtitle@gogo.xxx").to_json }
    let(:check) {Dj.second.id}
    before do
      100.times do
        create(:dj)
      end
      put("/dj/#{check}", body)
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it "is updated" do
      @dj = Dj.find(check)
      expect(@dj.title).to eq "updated title"
    end

    it "fails if dj doesn't exist" do
      put('/djs/23232322', body)
      expect(last_response.status).to eq 404
    end
  end

  # delete dj
  describe 'DELETE /djs/:id' do
    before do
      100.times do
        create(:dj)
      end

    end

    it 'is successful' do
      check = Dj.second.id
      delete "/djs/#{check}"
      expect(last_response.status).to eq 200
    end

    it 'does not respond the second time' do
      check = Dj.second.id
      delete "/djs/#{check}"
      delete "/djs/#{check}"
      expect(last_response.status).to eq 404
    end
  end
end




