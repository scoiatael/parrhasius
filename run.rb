require 'open-uri'
require 'nokogiri'
require 'securerandom'
require 'ruby-progressbar'
require 'fileutils'


class Downloader
  def save(link)
    open(folder, 'wb') do |file|
      file << open("https:" + link).read
    end
  end

  def download(link)
    img_link = link.attributes["href"]
    return unless img_link
    save(img_link.value)
  end

  def enumerate_link(link)
    html = Nokogiri(open(link).read)

    html.search('a').select { |l| l.children.size == 1 && l.children.first.to_s.match(/.*jpg$/) }
  end

  def initialize(main_page)
    @main_page = main_page
    @links = enumerate_link(@main_page)
    FileUtils.mkdir_p(folder)
  end

  def folder
    parts = @main_page.split("/")
    name = parts.last.empty? ? parts[-2] : parts.last
    ["imgs", name, SecureRandom.uuid + ".jpg"].join("/")
  end

  def each(&block)
    @links.each(&block)
  end

  def total
    @links.size
  end
end

pb = ProgressBar.create(:title => "Scrape", :total => ARGV.size, format: "%t (%c/%C): |\e[0;33m%B\e[0m| %E")
downloads = ARGV.map { |wp| pb.increment; Downloader.new(wp) }
pb.finish

total = downloads.map(&:total).sum
pb = ProgressBar.create(:title => "Download", :total => total, format: "%t (%c/%C): |\e[0;34m%B\e[0m| %E")
downloads.each do |download|
  download.each do |link|
    download.download(link)
    pb.increment
  end
end
pb.finish
