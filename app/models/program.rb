class Program
	include MongoMapper::Document

	key :name,			String
	key :shortname,			String, :unique => true
	key :description,		String
	key :image,			String
	key :times,			String
	key :subtitle,			String
	key :language,			String
	key :categories,		Array
	key :itunescategory, String
	key :creators,			Array
	key :coverimage,	String
  key :owners, 			Array #the emails that can operate on the program, dont share
	key :copyright, 		String  #copyright notice

	timestamps!

	many :episodes	

	attr_accessible 	:name, :shortname, :description, :image, :subtitle, :categories, :creators, :itunescategory, :copyright, :owners

	validates_presence_of :name
	validates_presence_of :shortname

 	def to_json(options = {})
		opts = options.merge(:only => [:name, :shortname, :description, :image, :times,
 											:subtitle, :language, :categories, :itunescategory,
											:creators, :coverimage, :copyright])
 		super(options)
 	end

	def to_json_with_episodes
		self.to_json(:include => [:episodes])
	end

	def self.get_all
		all_programs = Program.all
		if all_programs.empty?
			return []
		else
			return all_programs
		end
	end




end
