# frozen_string_literal: true

require_relative 'downloaders/fourchan'
require_relative 'downloaders/soup'

module Parrhasius
  class Download
    def initialize(downloader, storage)
      @downloader = downloader
      @storage = storage
    end

    def run(*links)
      pb = ProgressBar.create(title: 'Scrape', total: links.size, format: "%t (%c/%C): |\e[0;33m%B\e[0m| %E")
      downloads = links.map do |wp|
        pb.increment
        @downloader.new(wp)
      end
      pb.finish

      total = downloads.map(&:total).sum
      pb = ProgressBar.create(title: 'Download', total: total, format: "%t (%c/%C): |\e[0;34m%B\e[0m| %E")
      downloads.each do |download|
        download.each do |link|
          @storage.save(*download.download(link))
          pb.increment
        end
      end
      pb.finish
    end
  end
end
