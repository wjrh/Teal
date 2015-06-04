class CreateDjs < ActiveRecord::Migration
  def change
    create_table :djs do |t|
      t.string :net_id
      t.string :email
      t.string :dj_name
      t.string :real_name
      t.text :description

      t.timestamps null: false
    end
  end
end
