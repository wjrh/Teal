module Teal
	class Base
		# connect to the MongoDB instance
		mongo_client = MongoClient.new("localhost", 27017)
		db = mongo_client.db("teal_db")
		programs = db.collection("programs")

	end
end