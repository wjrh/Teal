module Teal
	class App < Sinatra::Base

		# upload audio files
		# checks if the episode exists
		# the file that is being uploaded will be renamed with filename and extension
		# file is written tot he raw foler in the media path
		# a resque job is placed for processing
		post "/episodes/:id/upload/?" do
			halt 400, "this episode does not exist" if not Episode.find(params["id"]).exists?
			file_extension = File.extname( params["file"]["filename"] )
			halt 400 if file_extension.length => 10 
			filename = params["id"] + file_extension
			path_to_file = File.join(Teal.config.media_path , "raw", filename)
			File.open(path_to_file, "w") do |f|
				f.write(params['file'][:tempfile].read)
			end
			p "New file uploaded to raw: #{filename} from ip: #{request.ip}"
			Resque.enqueue(Encode, filename)
		end
