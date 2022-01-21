class Folder < ApplicationRecord
  has_many :images, dependent: :destroy
end
