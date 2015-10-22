class Episode
	include MongoMapper::Document

		key :name,					String
		key :description,		String
		key :image,					String
		key :pubdate,				Time
	  timestamps!

		belongs_to :program

	  attr_accessible 	:name, :description, :image, :pubdate

	  validates_presence_of :name
end
