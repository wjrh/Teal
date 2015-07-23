class ChangeIsrcToUuid < ActiveRecord::Migration
  def change
  	rename_column :songs, :isrc, :uuid
  end
end
