require_relative 'spec_helper'

describe 'General API tests' do

	#adding djs
	describe "complete operation" do
		it "adds creators and programs" do
			# lets create a random dj
			dj1 = {
				:lafayetteid => "renand",
				:email => "renand@lafayette.edu",
				:name => "dj renren",
				:real_name => "Renan Dincer",
				:image_url => "url",
				:description => "a great guy"
				}.to_json

			# and we can post it to the database
			post "/creators", dj1

			# in result of this, we can expect the status to be 200
			expect(last_response.status).to eq 200

			# and we will have 1 creator in total
			expect(Creator.count).to eq 1

			# we can get the creators and compare its output to what we expect
			get "/creators"
			expect(last_response.body).to eq [{
				:id => Creator.first.id,
				:name => "dj renren",
				:image_url => "url"
				}].to_json

			#create more creators
			post "/creators", dj1
			post "/creators", dj1
			post "/creators", dj1
			post "/creators", dj1

			#create a program
			program1 = {
				:title => "a super duper show",
				:description => "an awesome show",
				:image_url => "http://placehold.it/300x300",
				:creators => [Creator.first.id, Creator.third.id]
			}.to_json

			post "/programs", program1

			expect(last_response.status).to eq 200

			# checks to see if invalid creator ids fail
			invalidprogram = {
				:title => "a super duper show",
				:description => "an awesome show",
				:image_url => "http://placehold.it/300x300",
				:creators => [188411234, Creator.first.id]
			}.to_json

			#this should not be approved
			post "/programs", invalidprogram

			expect(last_response.status).to eq 400 #because one fo the creators doesn't exist

			program2 = {
				:title => "a super duper show",
				:description => "an awesome show",
				:image_url => "http://placehold.it/300x300",
				:creators => [Creator.first.id, Creator.second.id]
			}.to_json

			#post another program that includes the first creator
			post "/programs", program2

			expect(last_response.status).to eq 200

			#now this creator should return two programs
			get "/creators/#{Creator.first.id}"

			# this creator has two programs
			expect(JSON.parse(last_response.body)["programs"].count).to eq 2

			#NOW THAT WE HAVE TWO PROGRAMS, WE CAN START ADDING EPISODES!
			episode1 = {
				:title => "An episode",
				:image_url => "http://image",
				:downloadable => true,
				:description => "this is a super duper episode"
			}.to_json

			#posting this episode to the 
			post "/programs/#{Program.first.id}/episodes", episode1

			expect(last_response.status).to eq 200

			expect(JSON.parse(last_response.body)['id']).to eq Episode.first.id

			episode1id = JSON.parse(last_response.body)['id']

			get "/episodes/#{episode1id}"

			expect(last_response.status).to eq 200
			expect(JSON.parse(last_response.body)['songs'].count).to eq 0

			song1 = {
				:artist => "U2",
				:uuid => "428734652987346523874782365",
        		:title => "James Songtgeg",
        		:label => "Columbia"
			}.to_json

			wrong_song = {
				:artist => "someguy"
			}.to_json

			post "/episodes/#{episode1id}/songs", wrong_song

			expect(last_response.status).to eq 400

			post "/episodes/#{episode1id}/songs", song1

			expect(last_response.status).to eq 200

			expect(Song.count).to eq 1
			expect(Playout.count).to eq 1

			post "/episodes/#{episode1id}/songs", song1

			expect(last_response.status).to eq 200

			expect(Song.count).to eq 1
			expect(Playout.count).to eq 2

			get "/episodes/#{episode1id}"

			expect(last_response.status).to eq 200
			expect(JSON.parse(last_response.body)['songs'].count).to eq 2
		end						
	end
end




