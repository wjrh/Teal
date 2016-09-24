require 'resque'
require 'taglib'
require_relative '../app'
require 'open3'
require 'fileutils'

module Teal
	class Encode
		@queue = :encode

		def self.perform(filepath, episode_id, current_user)
			episode = Episode.find(episode_id)

			if (!Episode.where(id: episode_id).exists? || !episode.program.owner?(current_user))
				File.delete(filepath) if File.exist?(filepath)
				return
			end

			path_to_encoded = File.join(Teal.config.media_path, "processed", "#{episode_id}.mp3")
      p path_to_encoded

			FileUtils.mkdir_p(File.dirname(path_to_encoded))
			encoding, encode_status = Open3.capture2e("avconv -analyzeduration 1000000000 -y -i #{filepath} -qscale:a 3 #{path_to_encoded}")
      
      if encode_status.success?
        TagLib::FileRef.open(path_to_encoded) do |fileref|
          if not fileref.null?
            tag = fileref.tag
            properties = fileref.audio_properties
            episode.type = "audio/mpeg"
            episode.length = properties.length  #song length in seconds
          end
        end
        obj = $s3.bucket('teal-media').object("#{episode_id}.mp3")
        obj.upload_file(path_to_encoded, {content_type: "audio/mpeg"})
        obj.wait_until_exists
        episode.audio_url = URI::join(Teal.config.api_subdomain, "download/"+ episode_id + ".mp3")
        episode.save
        File.delete(path_to_encoded)
        File.delete(filepath)
      else
        resp = $ses.send_email({
		  	  source: "problems@teal.cool", # required
			    destination: { # required
  			    to_addresses: ["renandincer@gmail.com"],
	  		  },
  			  message: { # required
	  		    subject: { # required
		  	      data: "transcode error for episode #{episode_id}", # required
			      },
  			    body: { # required
	  		      text: {
		  	        data: encoding, # required
			        },
  			    },
	  		  },
		  	})
      end
		end
	end
end
