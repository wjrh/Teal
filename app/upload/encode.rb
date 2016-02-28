require 'taglib'
require 'resque'
module Teal
	class Encode
		@queue = :encode

		# a resque job that processes a file in the raw folder
		# length
		# the converted file is put into the processed folder
		# if the process fails in any way, the output is logged and the file
		# that is created in result of the conversion is deleted if exists.
		# the new file created will have 
		def self.perform(filepath, episode_id)
			p "now PERFORMING =============  #{filepath}"
			# path_to_file = File.join(Teal.config.media_path , "raw", filename)
			# episode_id = File.basename(path_to_file, ".*")
			path_to_encoded = File.join(Teal.config.media_path,
																	"processed", "#{episode_id}.mp3")
			p "path to encodded = #{path_to_encoded}"
			episode = Epsiode.find(episode_id)
			p "episode found"
			#save the episode length to the epsiode
			TagLib::FileRef.open(filepath) do |fileref|
				unless fileref.null?
					tag = fileref.tag
					properties = fileref.audio_properties
					
					episode.length = properties.length  #song length in seconds
					p "episode length is #{episode.length}"
					episode.save
					p "episode saved"
				end
			end  # File is automatically closed at block end
		
			p "now going to encode"
			#TODO: add metadata to the encoded file
			encode_output = %x`ffmpeg -y -i #{filepath} -qscale:a 3 #{path_to_encoded}`
			p enc
			if $?.exitstatus > 0
				#there was a problem. log the error.
				p encode_output
				
				# get rid of the encoded file if there is a problem
				File.delete(path_to_encoded) if File.exist?(path_to_encoded)

				#TODO: do something with the error message, maybe send an email.
			else
				#encode succeeded
				p "encode succeeded: #{episode_id}.mp3"
				episode.audio_url = URI::join(Teal.config.media_path, "episodes", episode.id, ".mp3")
				episode.save
			end

		end
	end
end
