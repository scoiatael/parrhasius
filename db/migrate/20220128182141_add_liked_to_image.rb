class AddLikedToImage < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :liked, :boolean
  end
end
