# frozen_string_literal: true

class CreateDhashes < ActiveRecord::Migration[7.0] # rubocop:todo Style/Documentation
  def change
    create_table :dhashes do |t|
      t.string :value
      t.references :image, index: { unique: true }, null: false, foreign_key: true

      t.timestamps
    end
    add_index :dhashes, :value, unique: true
  end
end
