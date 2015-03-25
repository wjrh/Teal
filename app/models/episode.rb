class Episode < ActiveRecord::Base
	belongs_to :show
	has_and_belongs_to_many :songs
	has_many :airings
	has_and_belongs_to_many :djs
end
