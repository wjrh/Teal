class AddEpisodeRefToAirings < ActiveRecord::Migration
  def change
    add_reference :airings, :episode, index: true
    add_foreign_key :airings, :episodes
  end
end
