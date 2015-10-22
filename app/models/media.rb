class Media
  include MongoMapper::EmbeddedDocument

  key :url, String
  key :length, String
  key :type, String
end
