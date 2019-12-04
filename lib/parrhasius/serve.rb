# frozen_string_literal: true

require "mini_magick"

module Parrhasius
  class Serve
    def initialize(dir)
      thumbnails = Dir["#{dir}/thumbnail/*"].map { |p|  MiniMagick::Image.new(p) }
      @by_basename = Hash[thumbnails.map { |t| [File.basename(t.path), t] }]
    end

    def all
      @by_basename.values
    end

    def by_basename(basename)
      @by_basename.fetch(basename)
    end

    def full(path)
      MiniMagick::Image.new(path.sub('thumbnail', 'original'))
    end
  end
end
