class Image < ApplicationRecord
  belongs_to :folder

  def self.params_from_minimagick(image)
    { path: image.path, width: image.width, height: image.height }
  end
end
