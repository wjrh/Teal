require_relative 'spec_helper'

describe 'Episode API' do

	#list all episodes of a program
	describe "GET /programs/:program_id/episodes" do
		before do
			#create 10 dummy programs with episodes
			program = create(:program)
			10.times do
				program.episodes << create(:episode)
			end
			program.save
			get "/programs/#{program.id}/episodes"
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
	describe "POST /programs/:program_id/episodes" do

		let(:body){ {
			:title => "good episode", 	# episode name
			:description => "lalala",	# episode description
 			}.to_json }

		before do
			8.times do
				create(:program)
			end
			post "/programs/#{Program.second.id}/episodes", body
		end

		it "is successful" do
			expect(last_response.status).to eq 200
		end

		it 'has one episode' do
			expect(Program.second.episodes.count).to eq 1
		end

		it 'has two episodes if repeated' do
			post "/programs/#{Program.second.id}/episodes", body, { "CONTENT_TYPE" => "application/json" }
			expect(Program.second.episodes.count).to eq 2
		end

		it 'responds with 400 if title not included' do
      		post '/programs', {:foo => "bar"}.to_json, { "CONTENT_TYPE" => "application/json" }
      		expect(last_response.status).to eq 400
    	end

    	it 'creator information is correct' do
      		expect(Program.second.episodes.last.program.id).to eq Program.second.id
    	end
	end

	#get details about an episode
	describe "GET /episodes/:id" do

		before do
			#create 10 dummy programs with episodes
			program = create(:program)
			10.times do
				program.episodes << create(:episode)
			end
			program.save
			get "/episodes/#{program.episodes.first.id}"
		end

		it 'is successful' do
			expect(last_response.status).to eq 200
		end
	end

	#update an episode
	describe 'PUT /episodes/:id' do
		let(:body) { attributes_for(:episode, title: "updated name").to_json }
		let(:check) {Episode.second.id}
		before do
			8.times do
				program = create(:program)
				program.episodes << create(:episode)
				program.save
			end
			put "/episodes/#{Episode.second.id}", body, { "CONTENT_TYPE" => "application/json" }
		end

		it 'is successful' do
			expect(last_response.status).to eq 200
		end

		it "is updated" do
	      episode = Episode.find(check)
	      expect(episode.title).to eq "updated name"
	    end

	    it "fails if program doesn't exist" do
	      put('/episodes/23345346435634563456232322', body)
	      expect(last_response.status).to eq 404
	    end
	end

	#delete an episode
	describe 'DELETE /episodes/:id' do
	    before do
	      20.times do
	        program = create(:program)
			program.episodes << create(:episode)
			program.save
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