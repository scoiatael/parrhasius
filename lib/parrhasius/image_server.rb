# frozen_string_literal: true

require 'mini_magick'
require 'pathname'
require_relative 'image_server/page'
require 'zip'
require 'tempfile'

module Parrhasius
  class ImageServer
    attr_reader :dir

    def initialize(dir)
      @dir = dir
      thumbnails = Dir["#{dir}/thumbnail/*"].map { |p| MiniMagick::Image.new(p) }
      @by_basename = ::Hash[thumbnails.map { |t| [File.basename(t.path), t] }]
      @full = ::Hash[thumbnails.map { |t| [File.basename(t.path), _full(t.path)] }]
    end

    def first
      @by_basename.values.first
    end

    def all
      @by_basename.values
    end

    def ids
      @by_basename.keys
    end

    def by_basename(basename)
      @by_basename.fetch(basename)
    end

    def full(path)
      @full.fetch(File.basename(path))
    end

    def _full(path)
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

    def move(basename, dst)
      thumb_path = @by_basename.fetch(basename).path
      FileUtils.mv(thumb_path, dst.join("thumbnail").join(basename))
      FileUtils.mv(full_path(thumb_path), dst.join("original").join(basename))
    end

    def to_archive
      Tempfile.new([File.basename(@dir), '.zip'], "/tmp").tap do |t|
        Zip::OutputStream.open(t.path) do |z|
          ids.each do |id| 
            z.put_next_entry(id)
            z.print(File.read(full_path(by_basename(id).path)))
          end
        end
      end
    end

    private

    def full_path(path)
      Pathname.new(path.sub('thumbnail', 'original'))
    end
  end
end
