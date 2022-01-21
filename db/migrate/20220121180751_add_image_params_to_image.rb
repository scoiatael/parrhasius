class AddImageParamsToImage < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :height, :integer
    add_column :images, :width, :integer
  end
end
