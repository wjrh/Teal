# This is the file with the login logic.
# Login is performed via one time email links.
# This eliminates the password remembering problem and relies on emails

module Teal
	class App < Sinatra::Base

		#login a user
		get "/login/?" do
		end


		private

		def authenticate
			
		end

		def authenticated?
			!!current_user
		end

		def current_user
			@current_user
		end

	end
end

