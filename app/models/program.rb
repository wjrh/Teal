class Program
	include Mongoid::Document
	include Mongoid::Timestamps
	include ActiveModel::MassAssignmentSecurity
	
	# Listing the fields associated with Programs
	# shortname is used for most querying
	# Mongo's _id field is kept intact as expected
	# Owners are an array of emails that have write access on the program
	field :name,								type: String
	field :copyright, 					type: String
	field :shortname,						type: String #used for urls
	field :description,					type: String
	field :image,								type: String
	field :scheduled_time,			type: String
	field :subtitle,						type: String
	field :language,						type: String
	field :itunes_categories,		type: Array
	field :author,							type: String
	field :cover_image,					type: String
  field :owners, 							type: Array #people who are write access over the program
	field :tags,								type: Array
	field :active,							type: Boolean, default: true
	field :redirect_url,				type: String # url to redirect for the podcast xml
	field :organizations,				type: Array
	field :stream,							type: String #stream to capture the audio

	attr_accessible :name, :copyright, :shortname, :description, :image,
									:scheduled_time, :subtitle, :language, :itunes_categories,
									:author, :cover_image, :owners, :tags, :active,
									:redirect_url, :organizations, :stream

	# Index shortname and check for uniqueness
	index({ shortname: 1 }, { unique: true })
	
	# Keep track of episodes and raise an error if child
	# is not empty when the program is called to be destroyed
	has_many :episodes, autosave: true, dependent: :restrict
	
	# Validate presence of name, shortname and at lease one owner
	validates_presence_of :name
	validates_presence_of :shortname
	validates_presence_of :owners

	def owner?(current_user)
		self.owners.include?(current_user)
	end

	#overrides the json representation of this class.
	#this is the place where the necessary information is shared with public
	def as_json(options={})
		episodes.sort { |a,b| a.pubdate <=> pubdate }
		if options[:detailed]
			options = options.merge(:except => [:updated_at, :created_at, :_id, :program_id], :methods => [:id, :episodes])
			
		else
			options = options.merge(:only => [:name, :shortname, :description, :image, :subtitle, :tags, :author])
		end
		super(options)
	end
	

	# Returns all programs, and returns an empty array if none is found
	def self.get_all
		all_programs = Program.all.to_a
		all_programs.empty? ? [] : all_programs
	end

end

