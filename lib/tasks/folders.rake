namespace :folders do
  desc 'Import folder into sqlite db'
  task :import, [:path] => :environment do |_t, args|
    path = args.fetch(:path)
    imgs = Dir["#{path}/original/*"]
    puts("Found #{imgs.size} images")
    exit 1 unless imgs.size
    folder = Folder.create!(name: File.basename(path))
    folder.images.create(imgs.map { |i| Image.params_from_minimagick(MiniMagick::Image.new(i)) })
  end
end
