# frozen_string_literal: true

class CreateFolders < ActiveRecord::Migration[7.0] # rubocop:todo Style/Documentation
  def change
    create_table :folders do |t|
      t.string :name

      t.timestamps
    end
    add_index :folders, :name, unique: true
  end
end
