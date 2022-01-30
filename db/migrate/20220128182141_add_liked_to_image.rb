# frozen_string_literal: true

class AddLikedToImage < ActiveRecord::Migration[7.0] # rubocop:todo Style/Documentation
  def change
    add_column :images, :liked, :boolean
  end
end
