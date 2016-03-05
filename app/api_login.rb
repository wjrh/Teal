# This is the file with the login logic.
# Login is performed via one time email links.
require 'pony'
require 'securerandom'

module Teal
	class App < Sinatra::Base

		EMAIL_WAIT_TIMER = 480
		
		get "/whoami/?" do
			if current_user
				return current_user.to_s
			else
				return "nobody"
			end
		end

		#login a user
		post "/login/?" do
			request.body.rewind
			body =  request.body.read
			data = JSON.parse body
			params["email"] = data["email"] if data["email"]
			#halt if its not a valid email or empty
			if not valid_email?(params["email"])
				halt 400, "invalid email".to_json
			elsif has_valid_cookie?
				redirect Teal.config.front_end_subdomain
			else
				check_if_repeated_login_attempt
				send_login_link
			end
			halt 200, "please check your email to continue".to_json
		end

		get "/auth/?" do 
			identity = Identity.where(login_token: params["token"]).first
			#kick them out if they don't have a valid key
			if not identity
				halt 400, "link has expired or invalid link".to_json
			end

			#invalidate key and assign cookies
			identity.login_token = nil;
			identity.cookie = SecureRandom.base64(1024)
			identity.cookie_gen = Time.now
			identity.save

			response.set_cookie 'teal', identity.cookie
			redirect Teal.config.front_end_subdomain, identity.generate_api_key
		end
		
		#TODO: Incomplete method
		get "/key/?" do
			identity = Identity.where(cookie: request.cookies['teal']).first
			if identity
				return identity.generate_api_key
			else
				"you are unauthenticated"
			end
		end

		get "/logout/?" do
			identity = Identity.where(cookie: request.cookies['teal']).first
			halt 401, "you are unauthenticated" if not identity
			identity.cookie = nil
			identity.save
			return 200, "logged out"
		end

		#returns if the current user is authenticated
		def authenticated?
			!!current_user
		end

		#returns the email of the current user, alias to authenticate
		def current_user
			authenticate
		end

		private

		def has_valid_cookie?
			return Identity.where(cookie: request.cookies['teal']).exists?
		end

		def check_if_repeated_login_attempt
			identity = Identity.where(email: params["email"]).first
			return if not identity
			if identity.login_token_gen
				wait_time = EMAIL_WAIT_TIMER - (Time.now - last_attempt)
				headers "Retry-After" => wait_time.round.to_s
				halt 400, "too many attempts made, wait #{wait_time.round} seconds."
			end
		end

		def send_login_link
			identity = Identity.where(email: params["email"]).first_or_initialize
			token = identity.generate_login_token
			link = Teal.config.api_subdomain + "/auth?token=" + token
			expiry_time = Time.now + EMAIL_WAIT_TIMER
			message_with_link = "Please follow this link to log in:\n#{link}\n\nThis link will expire at #{expiry_time.utc}."

			Pony.mail({
				:to => params["email"],
				:from => Teal.config.login_source_email,
				:body => message_with_link,
				:subject => "Teal login",
				:via => :smtp,
				:via_options => {
					:address 	=> Teal.config.smtp_server,
					:port 		=> '587',
					:user_name=> Teal.config.smtp_user,
					:password => Teal.config.smtp_password,
					:authentication => :login
				}
				})
		end
		
		#returns the email of the current user
		def authenticate
			identity = Identity.where(cookie: request.cookies['teal']).first
			if identity
				return identity.email
			else
				return nil
			end
		end
		
		#TODO: make this regex more robust
		def valid_email?(email)
			return /@/.match(email)
		end
	end
end
