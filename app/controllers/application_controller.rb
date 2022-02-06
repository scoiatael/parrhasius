# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def with_format(format, &block)
    old_formats = formats
    self.formats = [format]
    block.call
    self.formats = old_formats
    nil
  end
end
