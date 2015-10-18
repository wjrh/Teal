class Program
	include MongoMapper::Document

		key :name,					String
		key :shortname,			String
		key :description,		String
		key :image,					String
		key :subtitle,			String
		key :categories,		Array
		key :episodes,			Array # foreign key
		key :creators,			Array # foreign key
	  timestamps!

	  attr_accessible 	:name, :shortname, :description, :image, :subtitle, :categories

	  validates_presence_of :name
	  validates_presence_of :shortname
end
