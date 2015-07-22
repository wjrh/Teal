module Teal
  class App < Sinatra::Base

  	# | GET | /programs/:id/episodes | list all episodes of a program |  |
  	get "/programs/:program_id/episodes/?" do 
  		program = Program.find_by_id(params['program_id'])
  		episodes = program.episodes
  		return episodes.to_json(:only => [:id, :title, :recording_url, :downloadable, :description])
  	end

	# | POST | /programs/:id/episodes | create a new episode |  |
	post "/programs/:program_id/episodes/?" do 
		request.body.rewind
		data = JSON.parse request.body.read
		episode = Episode.new(episode_params(data))

		episode.creators = episode.program.creators

		if episode.save
			return episode.to_json
		else
			halt 400, 'This episode could not be saved. Please fill all recessary fields'
		end
	end

	# | GET | /episodes/:id | get details about an episode |  |
	get "/episodes/:episode_id/?" do 
		episode = Episode.find_by_id(params['episode_id'])
		halt 404 if episode.nil? #halt if program doesn't exist
		return {
        :id => episode.id,
        :program_id => episode.program.id,
        :title => episode.title,
        :recording_url => episode.recording_url,
        :downloadable => episode.downloadable,
        :description => episode.description,
        :songs => episode.playouts.map{ |playout| {:id => playout.id, :artist => playout.song.artist, :title => playout.song.title}}
      }.to_json
	end

	# | PUT | /episodes/:id | update an episode |  |
	put "/episodes/:episode_id/?" do 
		request.body.rewind
		data = JSON.parse request.body.read
		episode = Episode.find_by_id(params['episode_id'])

		halt 404 if episode.nil? # halt if the program doesn't exist

		update = episode_params(data)

		if episode.update(update)
			return episode.to_json
		else
			halt 400, "This episode could not be saved"
		end
	end

	# | DELETE | /episodes/:id | delete an episode |  |
	delete "/episodes/:episode_id/?" do 
		episode = Episode.find_by_id(params['episode_id'])
		halt 404 if episode.nil? #halt if episode doesn't exist
		if episode.destroy
			status 200
		else
			halt 400, 'This episode could not be deleted.'
		end
	end

	def episode_params(data)
      hash = {
      	:program_id => params["program_id"],
        :title => data["title"],
        :recording_url => data ["recording_url"],
        :downloadable => data["downloadable"],
        :description => data["description"],
      }
      return hash
    end

  end
end