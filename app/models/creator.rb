class Creator < ActiveRecord::Base
	has_and_belongs_to_many :programs
	has_and_belongs_to_many :episodes

	# validations
	validates :email, presence: true
	validates :name, presence: true
	validates :real_name, presence: true
	validates :lafayetteid, presence: true
end
