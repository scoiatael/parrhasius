# frozen_string_literal: true

namespace :folders do
  desc 'Import folder into sqlite db'
  task :import, [:path] => :environment do |_t, args|
    path = args.fetch(:path)
    imgs = Dir["#{path}/original/*"]
    puts("Found #{imgs.size} images")
    exit 1 unless imgs.size
    folder = Folder.create!(name: File.basename(path))
    images = folder.images.create!(imgs.map { |i| Image.params_from_minimagick(MiniMagick::Image.new(i)) })
    images.each do |img|
      maybe_path = [img.path.sub('original', 'thumbnail'), img.thumbnail_path].select { |x| File.exist?(x) }.first
      Thumbnail.create!(image: img, path: maybe_path) unless maybe_path.nil?
    end
    Parrhasius::Dedup.new(progress_bar: ProgressBar).run(images)
  end
end
