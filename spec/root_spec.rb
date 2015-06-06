require_relative 'spec_helper'
 
describe 'Root Path' do
  describe 'GET /' do
    before { get '/' }
 
    it 'is successful' do
      expect(last_response.status).to eq 200
  	end
  	
  	it 'has the correct content' do
      expect(MultiJson.load(last_response.body)).to eq 'teal is the best color ever'
    end
  end
end