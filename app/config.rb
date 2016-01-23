require 'yaml'

module Teal
  # Public: The config located in config/teal.yml.
  #
  # Returns an OpenStruct so you can chain methods off of `Teal.config`.
  def self.config
    OpenStruct.new \
      :smtp_server 				=> ENV['SMTP_SERVER'] ||= yaml['smtp_server'],
			:cookie_secret		 	=> ENV['COOKIE_SECRET'] ||= yaml['cookie_secret'],
			:old_cookie_secret	=> ENV['OLD_COOKIE_SECRET'] ||= yaml['old_cookie_secret'],
			:domain 						=> ENV['DOMAIN'] ||= yaml['domain'],
			:front_end_subdomain=> ENV['FRONT_END_SUBDOMAIN'] ||= yaml['front_end_subdomain'],
			:api_subdomain 			=> ENV['API_SUBDOMAIN'] ||= yaml['api_subdomain'],
			:mongo_url 			=> ENV['MONGO_URL'] ||= yaml['mongo_url'],
			:redis_url			=> ENV['REDIS_URL'] ||= yaml['redis_url'],
			:smtp_user			=> ENV['SMTP_USER'] ||= yaml['smtp_user'],
			:smtp_password	=> ENV['SMTP_PASSWORD'] ||= yaml['smtp_password'],
			:login_source_email => ENV['LOGIN_SOURCE_EMAIL'] ||= yaml['login_source_email']
  end



	private

  # Load the config YAML.
  #
  # Returns a memoized Hash.
  def self.yaml
    if File.exist?('config/teal.yml')
      @yaml ||= YAML.load_file('config/teal.yml')
    else
      {}
    end
  end

end
