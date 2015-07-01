require_relative 'spec_helper'

describe 'Program API' do

  # get programs - list all programs
  describe 'GET /programs' do
    it 'is not successful if empty' do
      get '/programs'
      expect(last_response.status).to eq 404
    end

    it 'is successful' do
      create(:program)
      get '/programs'
      expect(last_response.status).to eq 200
    end
  end

  describe 'Program' do
    it 'gets created with a title' do
      program = Program.new
      program.title = "this is a title"
      program.save
    end

    it 'can have a description' do
      program = Program.new
      program.description = "this is a desc"
      program.save
    end
  end

  # post program with creator details
  describe 'POST /programs' do
    let(:body) { { :title => "title is this" }.to_json }
    before do
      post '/programs', body, { "CONTENT_TYPE" => "application/json" }
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'has one program' do
      expect(Program.count).to eq 1
    end

    it 'responds with 400 if title not included' do
      post '/programs', {:foo => "bar"}.to_json, { "CONTENT_TYPE" => "application/json" }
      expect(last_response.status).to eq 400
    end

    it 'can send with creator information' do
      50.times do
        create(:creator)
      end
      sample_creator_ids = [Creator.second.id, Creator.forty_two.id]
      post '/programs', {:creators => sample_creator_ids, :title => "title123"}.to_json
      expect(last_response.status).to eq 200
      expect(Program.find_by(:title => "title123").creators.first.id).to eq sample_creator_ids.first
    end
  end

  # get program details
  describe 'GET /programs/:id' do
    let(:check) {Program.second.id}
    before do
      create(:program)
      second_program = create(:program)
      100.times do
        create(:program)
      end
      get "/programs/#{check}"
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'returns 1 program' do
      response = MultiJson.load(last_response.body)
      expect(response.size).to eq 3 #id, title and description
    end

      it "fails if program doesn't exist" do
        get('/programs/23232322')
        expect(last_response.status).to eq 404
      end
    end


  # update program
  describe 'PUT /programs/:id' do
    let(:body) { attributes_for(:program, title: "updated title").to_json }
    let(:check) {Program.second.id}
    before do
      100.times do
        create(:program)
      end
      put("/programs/#{check}", body)
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it "is updated" do
      @program = Program.find(check)
      expect(@program.title).to eq "updated title"
    end

    it "fails if program doesn't exist" do
      put('/programs/2323232634563456342', body)
      expect(last_response.status).to eq 404
    end
  end

  # delete program
  describe 'DELETE /programs/:id' do
    before do
      100.times do
        create(:program)
      end

    end

    it 'is successful' do
      check = Program.second.id
      delete "/programs/#{check}"
      expect(last_response.status).to eq 200
    end

    it 'does not respond the second time' do
      check = Program.second.id
      delete "/programs/#{check}"
      delete "/programs/#{check}"
      expect(last_response.status).to eq 404
    end
  end
end




