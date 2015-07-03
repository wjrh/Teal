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
				:description => "a great guy"
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
				:image => "http://placehold.it/300x300",
				:creators => [Creator.first.id, Creator.third.id]
			}.to_json

			post "/programs", program1

			expect(last_response.status).to eq 200

			# checks to see if invalid creator ids fail
			invalidprogram = {
				:title => "a super duper show",
				:description => "an awesome show",
				:image => "http://placehold.it/300x300",
				:creators => [188411234, Creator.first.id]
			}.to_json

			#this should not be approved
			post "/programs", invalidprogram

			expect(last_response.status).to eq 400 #because one fo the creators doesn't exist

			program2 = {
				:title => "a super duper show",
				:description => "an awesome show",
				:image => "http://placehold.it/300x300",
				:creators => [Creator.first.id, Creator.second.id]
			}.to_json

			#post another program that includes the first creator
			post "/programs", program2

			expect(last_response.status).to eq 200

			#now this creator should return two programs
			get "/creators/#{Creator.first.id}"

			# this creator has two programs
			expect(JSON.parse(last_response.body)["programs"].count).to eq 2

		end						
	end
end




