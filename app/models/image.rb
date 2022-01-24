class Image < ApplicationRecord
  belongs_to :folder
  has_one :thumbnail, dependent: :destroy
  has_one :dhash, dependent: :destroy

  def self.params_from_minimagick(image)
    { path: image.path, width: image.width, height: image.height }
  end

  def thumbnail_path
    dir, base = File.split(path)
    File.join(dir, '.thumbnail', base)
  end

  def unique?
    return true unless dhash.nil?

    self.dhash = Dhash.create!(image: self, value: Parrhasius::Hash.call(path).strip)
  rescue ActiveRecord::RecordNotUnique
    false
  end
end
