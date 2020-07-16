# frozen_string_literal: true

Dir[__dir__ + '/downloaders/*.rb'].each do |f|
  require_relative f
end

module Parrhasius
  class Download
    def initialize(downloader, storage, progress_bar)
      @downloader = downloader
      @storage = storage
      @progress_bar = progress_bar
    end

    def run(*links)
      pb = @progress_bar.create(title: 'Scrape', total: links.size, format: "%t (%c/%C): |\e[0;33m%B\e[0m| %E")
      downloads = links.map do |wp|
        pb.increment
        @downloader.new(wp)
      end
      pb.finish

      total = downloads.map(&:total).sum
      pb = @progress_bar.create(title: 'Download', total: total, format: "%t (%c/%C): |\e[0;34m%B\e[0m| %E")
      downloads.each do |download|
        download.each do |link|
          @storage.save(*download.download(link))
          pb.increment
        end
      end
      pb.finish
    end


    def self.for(source)
      case source
      when /4chan/
        Parrhasius::Downloaders::FourChan
      when /soup/
        Parrhasius::Downloaders::Soup
      when /joemonster/
        Parrhasius::Downloaders::Joemonster
      else
        raise StandardError, "unexpected source: #{source}"
      end
    end
  end
end
