require_relative 'spec_helper'

describe 'Episode API' do

	#list all episodes of a show
	describe "GET /shows/:id/episodes" do
		before do
			#create 10 dummy shows with episodes
			10.times do
				show = create(:show)
				show.episodes << create(:episode)
				show.save
			end
			get "/shows/#{Show.last.id}/episodes"
		end

		it 'is successful' do
			expect(last_response.status).to eq 200
		end

		it 'has 10 episodes' do
			response = MultiJson.load(last_response.body)
			expect(response.size).to eq 10
		end
	end

	#create a new episode
	describe "POST /shows/:id/episodes" do

		let(:body){ {
			:name => "good episode", 	# episode name
			:description => "lalala",	# episode description
 			}.to_json }

		before do
			8.times do
				create(:show)
			end
			post "/shows/#{Show.second.id}/episodes", body, { "CONTENT_TYPE" => "application/json" }
		end

		it "is successful" do
			expect(last_response.status).to eq 200
		end

		it 'has one episode' do
			expect(Show.second.episodes.count).to eq 1
		end

		it 'has two episodes if repeated' do
			post "/shows/#{Show.second.id}/episodes", body, { "CONTENT_TYPE" => "application/json" }
			expect(Show.second.episodes.count).to eq 1
		end

		it 'responds with 400 if title not included' do
      		post '/shows', {:foo => "bar"}.to_json, { "CONTENT_TYPE" => "application/json" }
      		expect(last_response.status).to eq 400
    	end

    	it 'dj information is correct' do
      		expect(MultiJson.load(last_response.body).show).to eq Show.second.id
    	end
	end

	#get details about an episode
	describe "GET /episodes/:id" do

		before do
			get "/episodes/:id"
		end

		it 'is successful' do
			expect(last_response.status).to eq 200
		end

		it 'returns information we want' do
			expect(MultiJson.load(last_response.body)).to include("airings", "name", "downloadable", "show")
		end
	end

	#update an episode
	describe 'PUT /episodes/:id' do
		let(:body) { attributes_for(:episode, name: "updated name").to_json }
		let(:check) {Episode.second.id}
		before do
			8.times do
				show = create(:show)
				show.episodes << create(:episode)
				show.save
			end
			put "/epiosdes/#{Episode.second.id}/episodes", body, { "CONTENT_TYPE" => "application/json" }
		end

		it 'is successful' do
			expect(last_response.status).to eq 200
		end

		it "is updated" do
	      @episode = Episode.find(check)
	      expect(@episode.name).to eq "updated name"
	    end

	    it "fails if show doesn't exist" do
	      put('/episodes/23345346435634563456232322', body)
	      expect(last_response.status).to eq 404
	    end
	end

	#delete an episode
	describe 'DELETE /episodes/:id' do
	    before do
	      20.times do
	        show = create(:show)
			show.episodes << create(:episode)
			show.save
	      end
	  end


	    it 'is successful' do
	      check = Episode.second.id
	      delete "/episodes/#{check}"
	      expect(last_response.status).to eq 200
	    end

	    it 'does not respond the second time' do
	      check = Episode.second.id
	      delete "/episodes/#{check}"
	      delete "/episodes/#{check}"
	      expect(last_response.status).to eq 404
	    end
  	end
end