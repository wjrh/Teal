module Teal
	class App < Sinatra::Base
		get "/download/:id.?:format?" do
			episode_id = params['id']
			episode = Episode.find(episode_id)
			halt 404, "episode not found" if not episode
			p "TIME=#{Time.new.utc} FILE=#{episode_id}.mp3 IP=#{request.ip} HTTP_RANGE=#{request.env["HTTP_RANGE"]}"
    	episode.inc(hits: 1)
      obj = $s3.bucket('teal-media').object("#{episode_id}.mp3")
      if obj.exists?
        p "served from s3"
        s3_redirect_url = obj.presigned_url(:get, expires_in: 7200)
        redirect to(s3_redirect_url), 302
      else
			  halt 500, "episode recording not found"
      end
		end
	end
end
