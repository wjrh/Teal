module Teal
  class App < Sinatra::Base

  	# | GET | /shows/:id/episodes | list all episodes of a show |  |
  	get "/shows/:show_id/episodes" do 
  		show = Show.find_by_id(params['show_id'])
  		episodes = show.episodes
  		return episodes.to_json(:only => [:id, :name, :recording_url, :downloadable, :description])
  	end

	# | POST | /shows/:id/episodes | create a new episode |  |
	post "/shows/:show_id/episodes" do 
		request.body.rewind
		data = JSON.parse request.body.read
		episode = Episode.new(episode_params(data))

		if episode.save
			status 200
		else
			halt 400, 'This show could not be saved. Please fill all recessary fields'
		end
	end

	# | GET | /episodes/:id | get details about an episode |  |
	get "episodes/:episode_id" do 
		episode = Episode.find_by_id(params['episode_id'])
		halt 404 if episode.nil? #halt if show doesn't exist
		episode.to_json(only => [:id, :name, :recording_url, :downloadable, :description, :songs])
	end

	# | PUT | /episodes/:id | update an episode |  |
	put "/episodes/:episode_id" do 
		request.body.rewind
		data = JSON.parse request.body.read
		epsisode = Episode.find_by_id(params['episode_id'])

		halt 404 if episode.nil? # halt if the show doesn't exist

		update = episode_params(data)

		if show.update(update)
			status 200
		else
			halt 400, "This show could not be saved"
		end
	end

	# | DELETE | /episodes/:id | delete an episode |  |
	delete "/episodes/:episode_id" do 
		episode = Episode.find_by_id(params['episode_id'])
		halt 404 if episode.nil? #halt if episode doesn't exist
		if episode.destroy
			status 200
		else
			halt 400, 'This show could not be deleted.'
		end
	end

	def episode_params(data)
      hash = {
      	:show => params["show_id"],
        :name => data["name"],
        :recording_url => data ["recording_url"],
        :downloadable => data["downloadable"],
        :description => data["description"],
      }
      return hash
    end

  end
end