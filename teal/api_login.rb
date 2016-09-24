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

			resp = $ses.send_email({
			  source: Teal.config.login_source_email, # required
			  destination: { # required
			    to_addresses: [params["email"]],
			  },
			  message: { # required
			    subject: { # required
			      data: "Teal login", # required
			    },
			    body: { # required
			      html: {
			        data: message_with_link, # required
			      },
			    },
			  },
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
			return %Q[
				<!DOCTYPE html>

				<html style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">
				<head>
				  <title>Teal login</title>
				</head>

				<body>
				  <meta content="width=device-width" name="viewport">
				  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">

				  <div itemscope itemtype="http://schema.org/EmailMessage">
				    <div itemprop="potentialAction" itemscope itemtype="http://schema.org/ViewAction">
				      <link href="#{link}" itemprop="target">
				      <meta content="Login" itemprop="name">
				    </div>
				    <meta content="Login to Teal" itemprop="description">
				  </div>


				  <table bgcolor="#F6F6F6" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; background-color: #f6f6f6; margin: 0; padding: 0;">
				    <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">
				      <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0;" valign="top">
				      </td>

				      <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; display: block !important; max-width: 600px !important; clear: both !important; width: 100% !important; margin: 0 auto; padding: 0;" valign="top" width="600">
				        <div style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; max-width: 600px; display: block; margin: 0 auto; padding: 10px;">
				          <table bgcolor="#fff" cellpadding="0" cellspacing="0" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; border-radius: 3px; background-color: #fff; margin: 0; padding: 0; border: 1px solid #e9e9e9;" width="100%">
				            <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">
				              <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 20px;" valign="top">
				                <table cellpadding="0" cellspacing="0" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;" width="100%">
				                  <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">
				                    <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">Login to Teal by clicking the link below.</td>
				                  </tr>


				                  <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">
				                    <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">Teal will open logged in with your email address.</td>
				                  </tr>


				                  <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">
				                    <td align="center" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 0 0 20px;" valign="top">
				                      <a href="#{link}" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; color: #FFF; text-decoration: none; line-height: 2; font-weight: bold; text-align: center; cursor: pointer; display: inline-block; border-radius: 5px; text-transform: capitalize; background-color: #478589; margin: 0; padding: 0; border-color: #478589; border-style: solid; border-width: 10px 20px;">Login</a>
				                    </td>
				                  </tr>


				                  <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">
				                    <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">If you need a login token, it is <strong style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">#{token}</strong></td>
				                  </tr>
				                </table>
				              </td>
				            </tr>
				          </table>


				          <div style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; clear: both; color: #999; margin: 0; padding: 20px;">
				            <table style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;" width="100%">
				              <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0; padding: 0;">
				                <td align="center" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 12px; vertical-align: top; text-align: center; margin: 0; padding: 0 0 20px;" valign="top">This login link will expire at #{expiry_time.utc}.</td>
				              </tr>
				            </table>
				          </div>
				        </div>
				      </td>

				      <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0;" valign="top">
				      </td>
				    </tr>
				  </table>
				</body>
				</html>
			]
		end

	end
end
