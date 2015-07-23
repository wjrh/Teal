module Teal
  class App < Sinatra::Base

		# | POST | /episodes/:id/songs |  |  |
		post "/episodes/:episode_id/songs/?" do
			request.body.rewind  # in case someone already read it
  		data = JSON.parse request.body.read

  		episode = Episode.find_by_id(params['episode_id'])
      halt 404, "could not find the episode" if episode.nil? #halt if program doesn't exist

  		# if id exists use that
  		if !data['id'].nil?
  			song = Song.find_by(:id => data['id'])
  		# if uuid exists, use that
  		elsif !data['uuid'].nil?
  			song = Song.find_or_initialize_by(:uuid => data['uuid'])
  		# else we initialize a new song
  		elsif !data['title'].nil? &&
  				  !data['artist'].nil? &&
            !data['album'].nil? &&
            !data['label'].nil?
  			song = Song.new
  		else
  			halt 400, "not enough information to log a song"
  		end

  		#add all necessary details
  		song.update(song_params(data))
  		if !song.save
				halt 400, 'This episode could not be saved. Please fill all recessary fields'
			end

      #create a new playout
      playout = Playout.new
      playout.episode_id = episode.id
      playout.song_id = song.id

      #TODO(renandincer): add live listener calculation per playout here (maybe something async)
      #TODO(renandincer): solve the edge case when the client sends only a uuid and no album name

      if playout.save
      	return playout
      else
				halt 400, 'This playout could not be saved.'
			end
		end


	# | PUT | /episodes/:id/songs/:playout_id |  |  |
	# | DELETE | /episodes/:id/songs/:playout_id |  |  |


		def song_params(data)
      hash = {
      	:artist => data["artist"],
        :title => data["title"],
        :album => data ["album"],
        :label => data["label"],
      }
      return hash
    end
	end
end