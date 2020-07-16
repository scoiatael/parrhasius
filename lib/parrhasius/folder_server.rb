# frozen_string_literal: true

require 'digest'
require 'pathname'
require_relative 'log'

module Parrhasius
  class FolderServer
    def initialize(dir)
      @parent = Pathname.new(dir)
      @bin = @parent / "recycle_bin"
      @bin.mkdir unless @bin.exist?
      refresh!
    end

    def refresh!
      @children = @parent.children.select { |p| p.directory? && valid?(p) } .map { |p| [Digest::SHA2.new(256).hexdigest(p.realpath.to_s), p.relative_path_from(@parent)] }.to_h
    end

    def all
      @children
    end

    def by_id(folder_id)
      @parent.realpath.join @children.fetch(folder_id)
    end

    def move_to_bin(path)
      path = Pathname.new(path)
      new_path = @bin / path.basename

      Parrhasius::Log.info("Rename #{path} -> #{new_path}")

      path.rename(new_path)
    end

    private

    def valid?(p)
       p.join('thumbnail').exist? && p.join('original').exist?
    end
  end
end
