class AddProgramRefToEpisodes < ActiveRecord::Migration
  def change
    add_reference :episodes, :program, index: true
    add_foreign_key :episodes, :programs
  end
end
