class Episode
	include MongoMapper::Document

	key :name,				String
	key :description,		String
	key :image,				String
	key :pubdate,			Time
	key :starttime,			Time
	key :endtime,			Time
	key :guid, 				String
	timestamps!

	belongs_to 	:program
	many 		:medias

	attr_accessible 	:name, :description, :image, :pubdate, :guid, :medias

	validates_presence_of :name
end
