# frozen_string_literal: true

class AddThumbnailToFolder < ActiveRecord::Migration[7.0] # rubocop:todo Style/Documentation
  def change
    add_reference :folders, :thumbnail, null: true, foreign_key: true
  end
end
