class RenameImageColumnOnProgramsToImageUrl < ActiveRecord::Migration
  def change
  	rename_column :programs, :image, :image_url
  end
end
