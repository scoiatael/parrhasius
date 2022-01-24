class ChangeThumbnailMakeImageUnique < ActiveRecord::Migration[7.0]
  def change
    remove_index :thumbnails, :image_id
    add_index :thumbnails, :image_id, unique: true
  end
end
