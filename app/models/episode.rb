class Episode < ActiveRecord::Base
	belongs_to :program
	has_and_belongs_to_many :creators
	has_many :playouts
	has_many :songs, through: :playouts

	validates :title, presence: true
end
