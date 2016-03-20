module Teal
	class App < Sinatra::Base

		post "/episodes/:id/upload/?" do
			#TODO: we only check the last post so this might be a problem
			FlowController.new(params).post!(current_user)
	  end

	  #TODO: enable upload via the api
	  #TODO: work on encoding problems, test this
	  post "/episodes/:id/simpleupload/?" do
			halt 400, "this episode does not exist" if not Episode.where(id: params["id"]).exists?
			episode = Episode.find(params['id'])
			halt 401, "not allowed to perform such action" if not episode.program.owner?(current_user)

			filename = params["id"] + ".tmp"
			path_to_file = File.join(Teal.config.media_path , "raw", filename)
			directory_name = File.join(Teal.config.media_path , "raw")
			FileUtils.mkdir_p(directory_name) unless File.exists?(directory_name)
			request.body.rewind
			File.open(path_to_file, "w+") do |f|
				f.write(request.body.read)
			end
			p "New file uploaded to raw: #{filename} from ip: #{request.ip}"
	    Resque.enqueue(Encode, path_to_file, params['id'], current_user)
	  end

		# upload audio files
		# checks if the episode exists
		# the file that is being uploaded will be renamed with filename and extension
		# file is written tot he raw foler in the media path
		# a resque job is placed for processing
		# post "/episodes/:id/upload/?" do
		# 	filename = params["id"] + ".tmp"
		# 	path_to_file = File.join(Teal.config.media_path , "raw", filename)
		# 	directory_name = File.join(Teal.config.media_path , "raw")
		# 	FileUtils.mkdir_p(directory_name) unless File.exists?(directory_name)
		# 	File.open(path_to_file, "w+") do |f|
		# 		f.write(params['file'])
		# 	end
		# 	p "New file uploaded to raw: #{filename} from ip: #{request.ip}"
		# 	Resque.enqueue(Encode, filename)
		# end
	end
end
