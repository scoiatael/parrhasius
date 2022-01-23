# frozen_string_literal: true

require 'mini_magick'
require 'fileutils'

module Parrhasius
  class Minify
    def initialize(progress_bar)
      @progress_bar = progress_bar
    end

    def run(images)
      Parrhasius::WithThreadPool.new(
        pb: @progress_bar.create(title: 'Resizing', total: images.size, format: "%t (%c/%C): |\e[0;36m%B\e[0m| %E")
      ).run(images) do |pool, images, pb:|
        promises = images.map do |img|
          dir, basename = File.split(img.path)
          dest_dir = File.join(dir, '.thumbnail')
          FileUtils.mkdir_p(dest_dir)
          dst = File.join(dest_dir, basename)
          Concurrent::Promise.execute(executor: pool) do
            image = MiniMagick::Image.open(img.path)
            image.resize '256x256'
            image.write(dst)
            pb.borrow(&:increment)
            [img, dst]
          end
        end
        ps = Concurrent::Promise.zip(*promises)
        ps.wait!
        ps.value
      end
    end
  end
end
