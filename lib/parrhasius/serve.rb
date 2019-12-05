# frozen_string_literal: true

require 'mini_magick'
require_relative 'serve/page'

module Parrhasius
  class Serve
    def initialize(dir)
      thumbnails = Dir["#{dir}/thumbnail/*"].map { |p| MiniMagick::Image.new(p) }
      @by_basename = Hash[thumbnails.map { |t| [File.basename(t.path), t] }]
    end

    def all
      @by_basename.values
    end

    def by_basename(basename)
      @by_basename.fetch(basename)
    end

    def full(path)
      MiniMagick::Image.new(full_path(path))
    end

    def delete(basename)
      thumb = @by_basename.fetch(basename).path
      File.delete(thumb)
      File.delete(full_path(thumb))
    end

    private

    def full_path(path)
      path.sub('thumbnail', 'original')
    end
  end
end
