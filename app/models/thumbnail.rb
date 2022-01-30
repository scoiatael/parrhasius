# frozen_string_literal: true

class Thumbnail < ApplicationRecord
  belongs_to :image
  has_one :folder, dependent: :nullify
end
