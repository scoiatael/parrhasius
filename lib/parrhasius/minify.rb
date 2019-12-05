# frozen_string_literal: true

require 'mini_magick'
require 'fileutils'

module Parrhasius
  class Minify
    def run(src:, dest:)
      FileUtils.mkdir_p(dest)

      everything = discover(File.expand_path(src))
      dirs = everything.select(&:directory?)
      files = everything - dirs

      pool = Concurrent::FixedThreadPool.new(Concurrent.processor_count)

      pb = ProgressBar.create(title: 'Resizing', total: files.size, format: "%t (%c/%C): |\e[0;36m%B\e[0m| %E")
      cpb = Concurrent::MVar.new(pb)
      promises = files.map do |f|
        Concurrent::Promise.execute(executor: pool) do
          image = MiniMagick::Image.open(f.realpath)
          image.resize '256x256'
          image.write([dest, f.basename].join('/'))
          cpb.borrow(&:increment)
        end
      end
      Concurrent::Promise.all?(promises)
      pool.shutdown
      pool.wait_for_termination
      pb.finish
    end

    private

    def discover(dir)
      Dir["#{dir}/**/*"].map { |pn| Pathname.new(pn) }
    end
  end
end
