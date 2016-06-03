# This is the file with the login logic.
# Login is performed via one time email links.
require 'pony'
require 'securerandom'
require 'uri'

module Teal
	class App < Sinatra::Base

		EMAIL_WAIT_TIMER = 480
		
		get "/whoami/?" do
			cu = current_user
			if cu
				return cu.to_json
			else
				halt 404, "nobody".to_json
			end
		end

		#login a user
		post "/login/?" do
			request.body.rewind
			body =  request.body.read
			data = JSON.parse body
			params["email"] = data["email"].downcase if data["email"] #translate to lowercase-only email
			#halt if its not a valid email or empty
			if not valid_email?(params["email"])
				halt 400, "invalid email".to_json
			elsif has_valid_cookie? and current_user === params["email"]
				halt 200, "Already logged in".to_json
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

			cookie = identity.generate_cookie

			response.set_cookie 'teal', { value: cookie, secure: true, httponly: true }
			redirect URI::join(Teal.config.front_end_subdomain, 'loggedin') , identity.generate_api_key
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
			halt 200, "logged out".to_json
		end

		#returns if the current user is authenticated
		def authenticated?
			!!current_user
		end

		#returns the email of the current user, alias to authenticate
		def current_user
			authenticate
		end

		def getKey(user)
			Identity.where(email: user).first.api_key
		end

		private

		def has_valid_cookie?
			return Identity.where(cookie: request.cookies['teal']).exists?
		end

		def check_if_repeated_login_attempt
			identity = Identity.where(email: params["email"]).first
			return if not identity
			if identity.login_token_gen
				wait_time = EMAIL_WAIT_TIMER - (Time.now - identity.login_token_gen)
				if wait_time > 0
					headers "Retry-After" => wait_time.round.to_s
					halt 400, "too many attempts made, wait #{wait_time.round} seconds.".to_json
				end
			end
		end

		def send_login_link
			identity = Identity.where(email: params["email"]).first_or_initialize
			token = identity.generate_login_token
			link = Teal.config.api_subdomain + "/auth?token=" + token
			expiry_time = Time.now + EMAIL_WAIT_TIMER
			message_with_link = email_template(link, token, expiry_time)

			Pony.mail({
				:to => params["email"],
				:from => Teal.config.login_source_email,
				:body => message_with_link,
				:subject => "Teal login",
				:headers => { 'Content-Type' => 'text/html' },
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
			identity = Identity.where(cookie: request.cookies['teal']).first if request.cookies['teal']
			identity = Identity.where(api_key: request.env["HTTP_TEAL_API_KEY"]).first if request.env["HTTP_TEAL_API_KEY"]
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


		def email_template (link, token, expiry_time)
			return %Q[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> <html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">&#13; <head>&#13; <meta name="viewport" content="width=device-width" />&#13; <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />&#13; <title>Teal login</title>&#13; </head>&#13; &#13; <body style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: none; width: 100% !important; height: 100%; line-height: 1.6; background-color: #f6f6f6; margin: 0; padding: 0;" bgcolor="#f6f6f6">&#13; &#13; <table style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; background-color: #f6f6f6; margin: 0; padding: 0;" bgcolor="#f6f6f6">&#13; <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">&#13; <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0;" valign="top"></td>&#13; <td width="600" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; display: block !important; max-width: 600px !important; clear: both !important; width: 100% !important; margin: 0 auto; padding: 0;" valign="top">&#13; <div style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; max-width: 600px; display: block; margin: 0 auto; padding: 10px;">&#13; <table width="100%" cellpadding="0" cellspacing="0" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; border-radius: 3px; background-color: #fff; margin: 0; padding: 0; border: 1px solid #e9e9e9;" bgcolor="#fff">&#13; <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">&#13; <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 20px;" valign="top">&#13; <table width="100%" cellpadding="0" cellspacing="0" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">&#13; <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">&#13; <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">&#13; Login to Teal by clicking the link below.&#13; </td>&#13; </tr>&#13; <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">&#13; <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">&#13; Teal will open logged in with your email address.&#13; </td>&#13; </tr>&#13; <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">&#13; <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 0 0 20px;" align="center" valign="top">&#13; <a href="#{link}" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; color: #FFF; text-decoration: none; line-height: 2; font-weight: bold; text-align: center; cursor: pointer; display: inline-block; border-radius: 5px; text-transform: capitalize; background-color: #478589; margin: 0; padding: 0; border-color: #478589; border-style: solid; border-width: 10px 20px;">Login</a>&#13; </td>&#13; </tr>&#13; <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">&#13; <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">&#13; If you need a login token, it is <strong style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">#{token}</strong>&#13; </td>&#13; </tr>&#13; </table>&#13; </td>&#13; </tr>&#13; </table>&#13; <div style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; clear: both; color: #999; margin: 0; padding: 20px;">&#13; <table width="100%" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">&#13; <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">&#13; <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 12px; vertical-align: top; text-align: center; margin: 0; padding: 0 0 20px;" align="center" valign="top">This login link will expire at #{expiry_time.utc}.</td>&#13; </tr>&#13; </table>&#13; </div></div>&#13; </td>&#13; <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0;" valign="top"></td>&#13; </tr>&#13; </table>&#13; &#13; </body>&#13; </html>]
		end

	end
end
