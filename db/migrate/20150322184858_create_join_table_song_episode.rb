class CreateJoinTableSongEpisode < ActiveRecord::Migration
  def change
    create_join_table :songs, :episodes do |t|
      t.index [:song_id, :episode_id]
      t.index [:episode_id, :song_id]
      t.integer :seconds_from_start
    end
  end
end
