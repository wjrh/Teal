class CreateJoinTableCreatorShow < ActiveRecord::Migration
  def change
    create_join_table :creators, :shows do |t|
      t.index [:creator_id, :show_id]
      t.index [:show_id, :creator_id]
    end
  end
end
