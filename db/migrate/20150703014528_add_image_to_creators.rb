class AddImageToCreators < ActiveRecord::Migration
  def change
  	add_column :creators, :image_url, :string
  end
end
