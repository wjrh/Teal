class CreateJoinTableCreatorProgram < ActiveRecord::Migration
  def change
    create_join_table :creators, :programs do |t|
      t.index [:creator_id, :program_id]
      t.index [:program_id, :creator_id]
    end
  end
end
