# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'fileutils'

module Parrhasius
  module Downloaders
    MAX_ITERATIONS = 20
    class Soup
      def download(link)
        img_link = link.attributes['href']
        return unless img_link

        [img_link.to_s.split('/').last, open(img_link).read]
      end

      def enumerate_link(base_link)
        links = []
        link = base_link
        iterations = 0
        pb = ProgressBar.create(title: 'Collecting links', total: MAX_ITERATIONS, format: "%t (%c/%C): |\e[0;37m%B\e[0m| %E")
        while link && links.size < 200 && iterations < MAX_ITERATIONS
          html = Nokogiri(open(link).read)
          links += html.search('a.lightbox').to_a
          next_page = html.search('#load_more a').first
          link = next_page ? base_link + next_page['href'] : nil
          iterations += 1
          pb.increment
        end
        pb.finish

        links
      end

      def initialize(main_page)
        @main_page = main_page
        @links = enumerate_link(@main_page)
      end

      def each(&block)
        @links.each(&block)
      end

      def total
        @links.size
      end
    end
  end
end
