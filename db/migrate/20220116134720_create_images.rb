# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[7.0] # rubocop:todo Style/Documentation
  def change
    create_table :images do |t|
      t.string :path
      t.references :folder, null: false, foreign_key: true

      t.timestamps
    end
  end
end
