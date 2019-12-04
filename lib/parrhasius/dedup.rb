# frozen_string_literal: true

require 'pstore'
require 'pathname'
require 'ruby-progressbar'
require 'concurrent'

require_relative 'dedup/img'

module Parrhasius
  class Dedup
    def run(dir:, db:)
      everything = discover(File.expand_path(dir))
      dirs = everything.select(&:directory?)
      files = everything - dirs

      pool = Concurrent::FixedThreadPool.new(Concurrent.processor_count)

      imgs = files.map do |file|
        Img.new(file)
      end

      pb = ProgressBar.create(title: 'Hashing', total: files.size, format: "%t (%c/%C): |\e[0;33m%B\e[0m| %E")
      cpb = Concurrent::MVar.new(pb)
      promises = imgs.map do |i|
        Concurrent::Promise.execute(executor: pool) do
          i.hash!
          cpb.borrow(&:increment)
        end
      end
      Concurrent::Promise.all?(promises)
      pool.shutdown
      pool.wait_for_termination
      pb.finish

      index = PStore.new(db)
      index.transaction do
        pb = ProgressBar.create(title: 'Indexing', total: imgs.size, format: "%t (%c/%C): |\e[0;34m%B\e[0m| %E")
        imgs.each do |img|
          index[img.hash] ||= []
          index[img.hash] << img.path unless index[img.hash].index(img.path)
          pb.increment
        end
        pb.finish
      end

      dups = 0
      index.transaction do
        pb = ProgressBar.create(title: 'Removing', total: imgs.size, format: "%t: |\e[0;34m%B\e[0m| %E")
        imgs.each do |img|
          if File.basename(index[img.hash].first) != File.basename(img.path)
            img.path.delete
            dups += 1
          end
          pb.increment
        end
        pb.finish
      end
      puts "#{dups} duplicates removed"
    end

    private

    def discover(dir)
      Dir["#{dir}/**/*"].map { |pn| Pathname.new(pn) }
    end
  end
end
