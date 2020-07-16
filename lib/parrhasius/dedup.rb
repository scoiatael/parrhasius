# frozen_string_literal: true

require 'pstore'
require 'pathname'
require 'ruby-progressbar'
require 'concurrent'

require_relative 'dedup/img'

module Parrhasius
  class Dedup
    attr_reader :dir, :db, :imgs

    def initialize(dir:, db:, progress_bar:)
      @dir = dir
      @db = db

      everything = discover(File.expand_path(dir))
      dirs = everything.select(&:directory?)
      files = everything - dirs

      @imgs = files.map do |file|
        Img.new(file)
      end

      @pb = PB.new(progress_bar)
    end

    def hash!
      @pb.around(imgs, title: 'Hashing').map(&:hash!)
    end

    def index!
      with_pstore_index do |index|
        @pb.around(imgs, title: 'Indexing').each do |img|
          index[img.hash] ||= []
          index[img.hash] << img.path unless index[img.hash].index(img.path)
        end
      end
    end

    def dups
      [].tap do |d|
        with_pstore_index do |index|
          @pb.around(imgs, title: 'Removing').each do |img|
            d << img.path if dup?(index[img.hash].first, img)
          end
        end
      end
    end

    def run
      hash!
      index!

      dups.tap do |d|
        d.each(&:delete)
        puts "#{d.size} duplicates removed"
      end
    end

    private

    def with_pstore_index(&block)
      index = PStore.new(db)
      index.transaction { block.call(index) }
    end

    def dup?(original, other)
      File.basename(original) != File.basename(other.path)
    end

    def discover(dir)
      Dir["#{dir}/**/*"].map { |pn| Pathname.new(pn) }
    end
  end
end
