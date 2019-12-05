# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'fileutils'

module Parrhasius
  module Downloaders
    class Soup
      def download(link)
        img_link = link.attributes['href']
        return unless img_link

        [img_link.to_s.split('/').last, open(img_link).read]
      end

      def enumerate_link(base_link)
        links = []
        link = base_link
        while link && links.size < 200
          html = Nokogiri(open(link).read)
          links += html.search('a.lightbox').to_a
          next_page = html.search('#load_more a').first
          link = next_page ? base_link + next_page['href'] : nil
          p link
        end

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
