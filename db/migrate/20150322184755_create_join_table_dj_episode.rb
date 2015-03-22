class CreateJoinTableDjEpisode < ActiveRecord::Migration
  def change
    create_join_table :djs, :episodes do |t|
      # t.index [:dj_id, :episode_id]
      # t.index [:episode_id, :dj_id]
    end
  end
end
