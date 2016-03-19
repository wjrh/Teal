require 'resque'
require 'taglib'
require_relative '../app'
require 'open3'
require 'fileutils'

module Teal
	class Encode
		@queue = :encode

		def self.perform(filepath, episode_id, current_user)
			p "performing #{episode_id} at location #{filepath}"

			episode = Episode.find(episode_id)

			if (!Episode.where(id: episode_id).exists? || !episode.program.owner?(current_user))
				File.delete(filepath) if File.exist?(filepath)
				return
			end

			path_to_encoded = File.join(Teal.config.media_path, "processed", "#{episode_id}.mp3")

			FileUtils.mkdir_p(File.dirname(path_to_encoded))

			p "going to encode now"
			encoding, s2 = Open3.capture2e("avconv -analyzeduration 1000000000 -y -i #{filepath} -qscale:a 3 #{path_to_encoded}")
			p encoding
			p s2
			p "encode finished"

			TagLib::FileRef.open(path_to_encoded) do |fileref|
				if not fileref.null?
					tag = fileref.tag
					properties = fileref.audio_properties
					
					episode.length = properties.length  #song length in seconds
					episode.type = "audio/mpeg"
					episode.save
				end
			end


			# TODO: if episode transcode is successful do this:
			episode.audio_url = URI::join(Teal.config.api_subdomain, "download/"+ episode_id + ".mp3")
			episode.save

			#TODO: if episode transcode is NOT successful do this:
			#if transcode was not successful do this:
			# File.delete(path_to_encoded) if File.exist?(path_to_encoded)

		end
	end
end
