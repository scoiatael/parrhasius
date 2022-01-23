class CreateThumbnails < ActiveRecord::Migration[7.0]
  def change
    create_table :thumbnails do |t|
      t.string :path
      t.references :image, null: false, foreign_key: true

      t.timestamps
    end
  end
end
