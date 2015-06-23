class Dj < ActiveRecord::Base
	has_and_belongs_to_many :shows
	has_and_belongs_to_many :episodes

	# validations
	validates :email, presence: true
end
