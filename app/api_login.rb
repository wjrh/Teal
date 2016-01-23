# This is the file with the login logic.
# Login is performed via one time email links.
require 'pony'
require 'securerandom'

module Teal
	class App < Sinatra::Base

		EMAIL_WAIT_TIMER = 480
		
		get "/me/?" do
			return current_user.to_s
		end
		#login a user
		post "/login/?" do
			#halt if its not a valid email or empty
			if not valid_email?(params["email"])
				halt 400, "invalid email"
			end	
			
			#if the user has sent a valid cookie redirect or send login link
			if has_valid_cookie?
				redirect Teal.config.front_end_subdomain
			else
				check_if_repeated_login_attempt
				send_login_link
			end
			halt 200, "please check your email to continue"
		end

		get "/auth/?" do
			email = $redis.get(params["key"])
			#kick them out if they don't have a valid key
			if not email
				halt 400, "link has expired or invalid link"
			end
			#expire their email timer
			#invalidate key and assign cookies
			$redis.del(email)
			$redis.del(params["key"])
			session[:email] = email

			#redirect to the app
			redirect Teal.config.front_end_subdomain
		end
		
		#TODO: Incomplete method
		get "/key/?" do
			halt 401, "you are unauthenticated" 
			key = SecureRandom.urlsafe_base64(256,false)
		end


		private

		def has_valid_cookie?
			session[:email].eql?(params["email"])
		end

		def check_if_repeated_login_attempt
			last_attempt = $redis.get(params["email"])
			if last_attempt
				wait_time = EMAIL_WAIT_TIMER - (Time.now - Time.parse(last_attempt))
				headers "Retry-After" => wait_time.round.to_s
				halt 400, "too many attempts made, wait #{wait_time.round} seconds."
			end
		end

		def send_login_link
			#generate email key, commit it into redis and set it to expire
			key =  SecureRandom.urlsafe_base64(16,false)
			$redis.set(key,params["email"])
			$redis.expire(key, EMAIL_WAIT_TIMER)
			#set key to email as well to keep track of repeated login events	
			$redis.set(params["email"], Time.now.to_s)
			$redis.expire(params["email"], EMAIL_WAIT_TIMER)

			link = Teal.config.api_subdomain + "/auth?key=" + key
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
			if session[:email]
				return session[:email]
			else
				return nil
			end
		end

		#returns the email of the current user, alias to authenticate
		def current_user
			authenticate
		end

		#returns if the current user is the owner of the program
		def owner?(program)
			return program.owners.include?(current_user)
		end

		def authenticated?
			!!current_user
		end
		
		#TODO: make this regex more robust
		def valid_email?(email)
			return /@/.match(email)
		end

	end
end

