class AddShowRefToEpisodes < ActiveRecord::Migration
  def change
    add_reference :episodes, :show, index: true
    add_foreign_key :episodes, :shows
  end
end
