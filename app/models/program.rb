class Program
	include Mongoid::Document
	include Mongoid::Timestamps
	
	# Listing the fields associated with Programs
	# shortname is used for most querying
	# Mongo's _id field is kept intact as expected
	# Owners are an array of emails that have write access on the program
	field :name,								type: String
	field :copyright, 					type: String
	field :shortname,						type: String
	field :description,					type: String
	field :image,								type: String
	field :scheduled_time,			type: String
	field :subtitle,						type: String
	field :language,						type: String
	field :itunes_categories,		type: Array
	field :author,							type: String
	field :cover_image,					type: String
  field :owners, 							type: Array
	field :tags,								type: Array
	field :active,							type: Boolean, default: true
	field :redirect_url					type: String
	field :organizations				type: Array

	# Index shortname and check for uniqueness
	index({ shortname: 1 }, { unique: true })
	
	# Keep track of episodes and raise an error if child
	# is not empty when the program is called to be destroyed
	has_many :episodes, autosave: true, dependent: :restrict
	
	# Validate presence of name, shortname and at lease one owner
	validates_presence_of :name
	validates_presence_of :shortname
	validates_presence_of :owners

	# Override to_json method to provide more limited information
	# to include the episodes as well, add it to options
	# Will include the list of owners	if the person owns the program
 	def to_json(options = {})
		opts = options.merge(:only => [:name, :shortname, :description, :image, :times,
 											:subtitle, :language, :tags, :author, :cover_image, :copyright])
		opts = opts.merge(:only => [:owner]) if owner?(self)
 		super(opts)
 	end
	
	# Returns all programs, and returns an empty array if none is found
	def self.get_all
		all_programs = Program.all
		if all_programs.empty?
			return []
		else
			return all_programs
		end
	end

end
