class CreateCreators < ActiveRecord::Migration
  def change
    create_table :creators do |t|
      t.string :lafayetteid
      t.string :email
      t.string :name
      t.string :real_name
      t.text :description

      t.timestamps null: false
    end
  end
end
