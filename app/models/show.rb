class Show < ActiveRecord::Base
	has_and_belongs_to_many :creators
	has_many :episodes
	validates :title, presence: true
end
