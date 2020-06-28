# frozen_string_literal: true

require 'mini_magick'
require 'pathname'
require_relative 'image_server/page'

module Parrhasius
  class ImageServer
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
      @by_basename.delete(basename).path.tap do |thumbnail|
        full = full_path(thumbnail)
        File.delete(full) if full.exist?
      end
    end

    def set(basename)
      thumb = @by_basename.fetch(basename).path
      `feh --bg-max #{full_path(thumb)}`
    end

    private

    def full_path(path)
      Pathname.new(path.sub('thumbnail', 'original'))
    end
  end
end
