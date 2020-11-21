# frozen_string_literal: true

Dir[__dir__ + '/downloaders/*.rb'].each do |f|
  require_relative f
end

require_relative './with_thread_pool'

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
      Parrhasius::WithThreadPool.new(
        storage: @storage,
        pb: @progress_bar.create(title: 'Download', total: total, format: "%t (%c/%C): |\e[0;34m%B\e[0m| %E"),
      ).run(downloads, &method(:download_links))
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
        Parrhasius::Downloaders::Generic
      end
    end

    def download_links(pool, downloads, pb:, storage:)
      promises = downloads.flat_map do |download| 
        download.map do |link|
          Concurrent::Promise.execute(executor: pool) do
            filename, data = download.download(link)
            storage.borrow { |s| s.save(filename, data) }
            pb.borrow(&:increment)
          end
        end
      end
      Concurrent::Promise.zip(*promises).wait!
      pb.borrow(&:finish)
    end
  end
end
