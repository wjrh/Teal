require 'yaml'

module Teal
  # Public: The config located in config/teal.yml.
  #
  # Returns an OpenStruct so you can chain methods off of `Teal.config`.
  def self.config
    OpenStruct.new \
      :smtp_server 	=> yaml['smtp_server'],
			:cookie_secret			 	=> yaml['cookie_secret'],
			:old_cookie_secret		=> yaml['old_cookie_secret'],
			:domain 				=> yaml['domain'],
			:mongo_url 			=> yaml['mongo_url'],
			:mongo_port 		=> yaml['mongo_port'],
			:smtp_user			=> yaml['smtp_user'],
			:smtp_password	=> yaml['smtp_password']
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
