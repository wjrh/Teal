class Track
	include Mongoid::Document
	include Mongoid::Timestamps
	include ActiveModel::MassAssignmentSecurity

	field :title,						type: String
	field :artist,					type: String
	field :mbid,						type: String
	field :log_time,				type: Time

	# Tracks are embedded in episodes	
	embedded_in :episode

	attr_accessible :title, :artist, :mbid, :log_time

	def as_json(options={})
		options = options.merge(:only => [:title, :artist, :mbid, :log_time], :methods => [:id])
		super(options)
	end

end
