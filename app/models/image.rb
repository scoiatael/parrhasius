class Image < ApplicationRecord
  belongs_to :folder
  has_one :thumbnail, dependent: :destroy

  def self.params_from_minimagick(image)
    { path: image.path, width: image.width, height: image.height }
  end

  def thumbnail_path
    dir, base = File.split(path)
    File.join(dir, '.thumbnail', base)
  end
end
