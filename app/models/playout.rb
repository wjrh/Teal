class Playout < ActiveRecord::Base
	belongs_to :episodes
	belongs_to :songs
end