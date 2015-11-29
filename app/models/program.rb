class Program
	include MongoMapper::Document

	key :name,				String
	key :shortname,			String, :unique => true
	key :description,		String
	key :image,				String
	key :times,				String
	key :subtitle,			String
	key :language,			String
	key :categories,		Array
	key :creators,			Array
	timestamps!

	many :episodes
	

	attr_accessible 	:name, :shortname, :description, :image, :subtitle, :categories, :creators

	validates_presence_of :name
	validates_presence_of :shortname
end
