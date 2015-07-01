class Song < ActiveRecord::Base
	has_many :playouts
	has_many :episodes, through: :playouts
end
