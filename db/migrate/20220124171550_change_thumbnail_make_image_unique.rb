# frozen_string_literal: true

class ChangeThumbnailMakeImageUnique < ActiveRecord::Migration[7.0] # rubocop:todo Style/Documentation
  def change
    remove_index :thumbnails, :image_id
    add_index :thumbnails, :image_id, unique: true
  end
end
