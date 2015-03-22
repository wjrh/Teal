class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :name
      t.string :recording_url
      t.boolean :downloadable
      t.integer :online_listens

      t.timestamps null: false
    end
  end
end
