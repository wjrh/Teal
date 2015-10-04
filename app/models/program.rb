module Teal
	class Program < Base

		def listAll #list all programs
			programs.find.to_a
			output = programs.find(:fields => ["title", "shortname", "description", "image", "subtitle", "categories"]).to_a
			(output || {}) #return output or empty set
		end

		def add(params)
		  #check for the existance of essential information
  		if [:title, :description, :subtitle].all? {|s| params.key? s}
  			return false
  		else
  			# extract information and disregard extra keys one might have included
  			acceptedInformation = ["title", "shortname", "description", "image", "subtitle", "episodes", "creators"]
  			document = params.select {|k,v| acceptedInformation.include?(k) }
  			return programs.insert(document)
      end
		end

		def find(shortname)
			return programs.find("shortname" => shortname).to_a.first
		end

		
	end
end
