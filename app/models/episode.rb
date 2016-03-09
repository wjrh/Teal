class Episode
	require"securerandom"
	include Mongoid::Document
	include Mongoid::Timestamps
	include ActiveModel::MassAssignmentSecurity
	
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
	field :length,				type: String
	field :type,					type: String, default: "audio/mpeg"
	field :audio_url,     type: String


	attr_accessible :name, :description, :image, :pubdate,
									:start_time, :end_time, :guid, :length,
									:type, :audio_url


	# Episodes belong to programs
	belongs_to :program
	# Episode embeds many tracks
	embeds_many :tracks

	# Validate the presence of two essential items
	validates_presence_of :name
	validates_presence_of :guid

	# Create a globally unique id if none is supplied already
	after_initialize do |document|
		document.guid = SecureRandom.uuid if not document.guid
		document.pubdate = Time.now if not document.guid
	end


	#overrides the json representation of this class.
	#this is the place where the necessary information is shared with public
	# TODO(renandincer): dont display past timed episodes
	def as_json(options={})
		if options[:detailed]
			options = options.merge(:except => [:updated_at, :created_at, :program_id, :_id], :methods => [:id, :program])
		else
			options = options.merge(:only => [:name, :image, :pubdate, :audio_url])
		end
		super(options)
	end
	
end
