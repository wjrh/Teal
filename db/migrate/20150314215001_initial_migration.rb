class InitialMigration < ActiveRecord::Migration
  def change
  	create_table :djs do |t|
  		t.string :net_id
  		t.string :email
  		t.string :name
  		t.string :real_name
  		t.text :description
  	end

  	create_table :shows do |t|
  		t.string :title
  		t.text :description
  	end

  	create_table :airings do |t|
  		t.datetime :start_time
  		t.datetime :end_time
  		t.integer :listens
  	end

  	add_reference :airings, :episode, index:true

  	create_table :episodes do |t|
  		t.string :name
  		t.string :recording_url
  		t.boolean :downloadable
  		t.integer :online_listens 
  	end

  	create_join_table :songs, :episodes do |t|
  		t.integer :seconds_from_start
  	end

  	create_table :songs do |t|
  		t.string :artist
  		t.string :title
  	end

  	create_join_table :djs, :episodes
  	create_join_table :djs, :shows

  end
end
