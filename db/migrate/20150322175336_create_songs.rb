class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :artist
      t.string :title
      t.string :ISRC
      t.string :album
      t.string :label

      t.timestamps null: false
    end
  end
end
