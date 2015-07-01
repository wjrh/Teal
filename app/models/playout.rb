class Playout < ActiveRecord::Base
	belongs_to :episodes
	belongs_to :songs

	validates :title, presence: true
end