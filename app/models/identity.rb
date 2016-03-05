class Identity
	require"securerandom"
	include Mongoid::Document

	field :email,					type: String
	field :login_token	,	type: String
	field :cookie,				type: String # a way to sign in
	field :api_key,				type: String # another way to sign in
	field :publickey,			type: String

	field :login_token_gen,	type: Time
	field :cookie_gen,			type: Time
	field :api_key_gen,			type: Time
	field :last_use,				type: Time

	validates_presence_of :email	

	def generate_login_token
		self.login_token = SecureRandom.urlsafe_base64(16,false)
		self.login_token_gen = Time.now
		self.save
		return self.login_token
	end

	def generate_api_key
		self.api_key = SecureRandom.base64(64)
		self.api_key_gen = Time.now
		self.save
		return self.api_key
	end

end
