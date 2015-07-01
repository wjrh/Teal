class CreatePlayout < ActiveRecord::Migration
  def change
	  	create_table :playouts do |t|
	  		t.integer :episode_id
	  		t.integer :song_id
	      t.integer :live_listeners
	      t.integer :soundexchange_reporting, default: true

	      t.timestamps null: false
	  end

	  add_foreign_key :playouts, :episodes
	  add_foreign_key :playouts, :songs
  end
end