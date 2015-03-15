module Api
	module V1
		class ShowsController < ApplicationController

			def index
				@currentshows = Show.all.to_a
			end

			def create 
				@currentshow = Show.new(show_params)
				@currentshow.save
			end

			def edit
			end

			private
		    # Using a private method to encapsulate the permissible parameters
		    # is just a good pattern since you'll be able to reuse the same
		    # permit list between create and update. Also, you can specialize
		    # this method with per-user checking of permissible attributes.
		    def show_params
		      params.require(:show).permit(:title, :description, :djs => [])
		    end

		end
	end
end