# frozen_string_literal: true

class AddImageParamsToImage < ActiveRecord::Migration[7.0] # rubocop:todo Style/Documentation
  def change
    add_column :images, :height, :integer
    add_column :images, :width, :integer
  end
end
