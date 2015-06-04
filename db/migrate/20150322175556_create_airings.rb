class CreateAirings < ActiveRecord::Migration
  def change
    create_table :airings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :listens

      t.timestamps null: false
    end
  end
end
