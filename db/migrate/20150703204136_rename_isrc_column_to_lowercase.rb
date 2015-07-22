class RenameIsrcColumnToLowercase < ActiveRecord::Migration
  def change
  	rename_column :songs, :ISRC, :isrc
  end
end
