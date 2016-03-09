class Track
	include Mongoid::Document
	include Mongoid::Timestamps

	field :title,						type: String
	field :artist,					type: String
	field :mbid,						type: String

	# Tracks are embedded in episodes	
	embedded_in :episode

	def as_json(options={})
		options = options.merge(:only => [:title, :artist, :mbid], :methods => [:id])
		super(options)
	end

end
