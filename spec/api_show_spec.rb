require_relative 'spec_helper'

describe 'Show API' do

  # get shows - list all shows
  describe 'GET /shows' do
    it 'is not successful if empty' do
      get '/shows'
      expect(last_response.status).to eq 404
    end

    it 'is successful' do
      create(:show)
      get '/shows'
      expect(last_response.status).to eq 200
    end
  end

  describe 'Show' do
    it 'gets created with a title' do
      show = Show.new
      show.title = "this is a title"
      show.save
    end
  end

  # post show with dj details
  describe 'POST /shows' do
    let(:body) { { :title => "title is this" }.to_json }
    before do
      post '/shows', body, { "CONTENT_TYPE" => "application/json" }
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'has one show' do
      expect(Show.count).to eq 1
    end

    it 'responds with 404 if title not included' do
      post '/shows', {:foo => "bar"}.to_json, { "CONTENT_TYPE" => "application/json" }
      expect(last_response.status).to eq 400
    end
  end

  # get show details
  describe 'GET /shows/:id' do
    let(:check) {Show.second.id}
    before do
      create(:show)
      second_show = create(:show)
      100.times do
        create(:show)
      end
      get "/shows/#{check}"
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'returns 1 show' do
      response = MultiJson.load(last_response.body)
      expect(response.size).to eq 3 #id, title and description
    end

      it "fails if show doesn't exist" do
        get('/shows/23232322')
        expect(last_response.status).to eq 404
      end
    end


  # update show
  describe 'PUT /shows/:id' do
    let(:body) { attributes_for(:show, title: "updated title").to_json }
    let(:check) {Show.second.id}
    before do
      100.times do
        create(:show)
      end
      put("/shows/#{check}", body)
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it "is updated" do
      @show = Show.find(check)
      expect(@show.title).to eq "updated title"
    end

    it "fails if show doesn't exist" do
      put('/shows/23232322', body)
      expect(last_response.status).to eq 404
    end
  end

  # delete show
  describe 'DELETE /shows/:id' do
    before do
      100.times do
        create(:show)
      end

    end

    it 'is successful' do
      check = Show.second.id
      delete "/shows/#{check}"
      expect(last_response.status).to eq 200
    end

    it 'does not respond the second time' do
      check = Show.second.id
      delete "/shows/#{check}"
      delete "/shows/#{check}"
      expect(last_response.status).to eq 404
    end
  end
end




