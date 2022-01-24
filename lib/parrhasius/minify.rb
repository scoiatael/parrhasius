# frozen_string_literal: true

require 'mini_magick'
require 'fileutils'

module Parrhasius
  class Minify
    def initialize(progress_bar:)
      @progress_bar = progress_bar
    end

    def run(images)
      mkdirs!(images)
      Parrhasius::WithThreadPool.new(
        pb: @progress_bar.create(title: 'Resizing', total: images.size, format: "%t (%c/%C): |\e[0;36m%B\e[0m| %E")
      ).run(&parallel_minify(images))
      images.each do |img|
        Thumbnail.create!(path: img.thumbnail_path, image: img)
      end
    end

    private

    def parallel_minify(images)
      lambda do |pool, pb:|
        promises = images.map do |img|
          Concurrent::Promise.execute(executor: pool, &resize(img, pb))
        end
        Concurrent::Promise.zip(*promises).wait!
      end
    end

    def mkdirs!(images)
      images.map(&:thumbnail_dir).uniq.each { |d| FileUtils.mkdir_p(d) }
    end

    def resize(img, pb)
      lambda do
        image = MiniMagick::Image.open(img.path)
        image.resize '256x256'
        image.write(img.thumbnail_path)
        pb.borrow(&:increment)
      end
    end
  end
end
