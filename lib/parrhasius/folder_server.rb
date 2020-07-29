# frozen_string_literal: true

require 'digest'
require 'pathname'
require_relative 'log'

module Parrhasius
  class FolderServer
    attr_reader :by_id
    def initialize(dir)
      @parent = Pathname.new(dir)
      @bin = @parent / "recycle_bin"
      @bin.mkdir unless @bin.exist?
      @semaphore = Mutex.new
      refresh!
    end

    def refresh!
      synchronize do
        @children = @parent.children.select { |p| p.directory? && valid?(p) } .map { |p| [Digest::SHA2.new(256).hexdigest(p.realpath.to_s), p.relative_path_from(@parent)] }.to_h
        @by_id = ::Hash.new { |s, folder_id| s[folder_id] = Parrhasius::ImageServer.new(_by_id(folder_id)) }
      end
    end

    def all
      @children
    end

    def move_to_bin(path)
      synchronize do
        path = Pathname.new(path)
        new_path = @bin / path.basename

        Parrhasius::Log.info("Rename #{path} -> #{new_path}")

        path.rename(new_path)
      end
    end

    private

    def valid?(p)
       p.join('thumbnail').exist? && p.join('original').exist?
    end

    def synchronize(&block)
      @semaphore.synchronize(&block)
    end

    def _by_id(folder_id)
      @parent.realpath.join @children.fetch(folder_id)
    end
  end
end
