class Episode
	require "SecureRandom"
	include Mongoid::Document
	include Mongoid::Timestamps
	
	# Listing the fileds associated with Programs
	# Pubdate is the date the epsode is intended to be public
	# start_time and end_time is for live shows
	# guid is a globally unique id for itunes to use for podcasting
	field :name,					type: String
	field :description,		type: String
	field :image,					type: String
	field :pubdate,				type: Time
	field :start_time,		type: Time
	field :end_time,			type: Time
	field :guid, 					type: String

	# media related fields length is either in hh:mm:ss or mm:ss format
	field :raw_file,			type: String
	field :length,				type: String
	field :type,					type: String
	field :processed,			type: Boolean, default: false
	field :audio_url,			type: String

	# Index guid and check for uniqueness
	index({ shortname:1 }, { unique: true })

	# Episodes belong to programs
	belongs_to 	:program

	# Validate the presence of two essential items
	validates_presence_of :name
	validates_presence_of :guid

	# Create a globally unique id if none is supplied already
	before_save do |document|
		document.guid = SecureRandom.uuid if not document.guid
	end

	# Override to_json to limit the information shared
	# add the full audio url in the returned document
	# rewrite the _id field with a plain old id field.
	def to_json(options = {})
		opts = options.merge(:only => [:name, :description, :image, :pubdate, :start_time, :end_time, 
												 :guid, :length, :type, :processed],
												:methods => [:audio_url])
		attrs = super(opts)
		attrs["id"] = attrs["_id"]
		return attrs
	end


	# Method returns if the episode is ready for processing
	# Episode is ready for processing if there is a raw file and it is not processed
	def self.ready_for_processing
		true if self.rawfile and not self.processed
	end

end
