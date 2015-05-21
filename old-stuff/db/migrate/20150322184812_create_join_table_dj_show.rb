class CreateJoinTableDjShow < ActiveRecord::Migration
  def change
    create_join_table :djs, :shows do |t|
      t.index [:dj_id, :show_id]
      t.index [:show_id, :dj_id]
    end
  end
end
