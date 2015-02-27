class EpisodesController < ApplicationController
  def episodes
  	
  end

  def new
  	@products = params["Name"]
  	# here is where you add it to the db
  end
end
