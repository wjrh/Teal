class CreateCreators < ActiveRecord::Migration
  def change
    create_table :creators do |t|
      t.string :net_id
      t.string :email
      t.string :creator_name
      t.string :real_name
      t.text :description

      t.timestamps null: false
    end
  end
end
