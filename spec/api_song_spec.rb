require_relative 'spec_helper'

describe 'Song API' do



  # add a new playout to an episode
  describe 'POST /episodes/:id/songs' do
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




  # change the playout
  describe 'PUT /episodes/:id/songs/:playout_id' do
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




  # delete the playout
  describe 'DELETE /episodes/:id/songs/:playout_id' do
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



end