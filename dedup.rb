require "pstore"
require "digest"
require "pathname"
require "ruby-progressbar"

def discover
  Dir["imgs/**/*.jpg"].map { |pn| Pathname.new(pn) }
end

everything = discover
dirs = everything.select(&:directory?)
files = everything - dirs

dirs.each(&:delete)

class Img
  attr_reader :hash, :path

  def initialize(path)
    @path = path
    @hash = do_hash(path)
  end

  private

  def do_hash(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end

pb = ProgressBar.create(:title => "Hashing", :total => files.size, format: "%t: |\e[0;33m%B\e[0m| %E")
imgs = files.map do |file|
  pb.increment
  Img.new(file)
end
pb.finish

index = PStore.new("index.pstore")
index.transaction do
  pb = ProgressBar.create(:title => "Indexing", :total => imgs.size, format: "%t: |\e[0;34m%B\e[0m| %E")
  imgs.each do |img|
    index[img.hash] = img unless index[img.hash]
    pb.increment
  end
  pb.finish
end

index.transaction(true) do
  pb = ProgressBar.create(:title => "Deduping", :total => imgs.size, format: "%t: |\e[0;35m%B\e[0m| %E")
  dups = imgs.select { |f| pb.increment(); index[f.hash].path != f.path }
  pb.finish
  p({total: files.size, dups: dups.size})
  dups.map(&:path).each(&:delete)
end
