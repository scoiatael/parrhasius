# frozen_string_literal: true

Dir["#{__dir__}/downloaders/*.rb"].each do |f|
  require_relative f
end

require_relative './with_thread_pool'

module Parrhasius
  class Download # rubocop:todo Style/Documentation
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
        pb: @progress_bar.create(title: 'Download', total: total, format: "%t (%c/%C): |\e[0;34m%B\e[0m| %E")
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

    # rubocop:todo Naming/MethodParameterName
    def download_links(pool, downloads, pb:) # rubocop:todo Metrics/MethodLength, Naming/MethodParameterName
      # rubocop:enable Naming/MethodParameterName
      promises = downloads.flat_map do |download|
        download.map do |link|
          Concurrent::Promise.execute(executor: pool) do
            filename, data = download.download(link)
            path = File.join(@storage, filename)
            File.binwrite(path, data)
            pb.borrow(&:increment)
            MiniMagick::Image.new(path)
          end
        end
      end
      ps = Concurrent::Promise.zip(*promises)
      ps.wait!
      pb.borrow(&:finish)
      ps.value
    end
  end
end
