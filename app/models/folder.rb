class Folder < ApplicationRecord
  has_many :images, dependent: :destroy
  belongs_to :thumbnail

  def avatar!
    return thumbnail unless thumbnail.nil?

    self.thumbnail = images.first.thumbnail
    save!
    thumbnail
  end
end
