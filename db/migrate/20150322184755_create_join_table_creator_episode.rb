class CreateJoinTableCreatorEpisode < ActiveRecord::Migration
  def change
    create_join_table :creators, :episodes do |t|
      t.index [:creator_id, :episode_id]
      t.index [:episode_id, :creator_id]
    end
  end
end
