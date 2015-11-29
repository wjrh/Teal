class Media
  include MongoMapper::EmbeddedDocument

  key :url,		String
  key :length,	String
  key :type,	String
  timestamps!
  
  attr_accessible 	:url, :length, :type
end
