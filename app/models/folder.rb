# frozen_string_literal: true

class Folder < ApplicationRecord # rubocop:todo Style/Documentation
  has_many :images, dependent: :destroy
  belongs_to :thumbnail, optional: true

  def avatar!
    return thumbnail unless thumbnail.nil?

    self.thumbnail = images.first.thumbnail
    save!
    thumbnail
  end
end
