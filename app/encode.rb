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
		def self.perform(filename)
			path_to_file = File.join(Teal.config.media_path , "raw", filename)
			episode_id = File.basename(path_to_file, ".*")
			path_to_encoded = File.join(Teal.config.media_path,
																	"processed", "#{episode_id}.mp3")

			episode = Epsiode.find(episode_id)
			
			#save the episode length to the epsiode
			TagLib::FileRef.open("wake_up.flac") do |fileref|
				unless fileref.null?
					tag = fileref.tag
					properties = fileref.audio_properties
					
					episode.length = properties.length  #song length in seconds
					episode.save

				end
			end  # File is automatically closed at block end
		

			#TODO: add metadata to the encoded file
			encode_output = %x`ffmpeg -y -i #{path_to_file} -qscale:a 3 #{path_to_encoded}`

			if $?.exitstatus > 0
				#there was a problem. log the error.
				$stderr.puts encode_output
				
				# get rid of the encoded file if there is a problem
				File.delete(path_to_encoded) if File.exist?(path_to_encoded)

				#TODO: do something with the error message, maybe send an email.
			else
				#encode succeeded
				p "encode succeeded: #{episode_id}.mp3"
			end

		end
	end
end
