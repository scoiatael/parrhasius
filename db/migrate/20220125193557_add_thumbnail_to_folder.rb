class AddThumbnailToFolder < ActiveRecord::Migration[7.0]
  def change
    add_reference :folders, :thumbnail, null: true, foreign_key: true
  end
end
