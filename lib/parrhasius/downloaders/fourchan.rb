# frozen_string_literal: true

require 'down'
require 'nokogiri'
require 'securerandom'

module Parrhasius
  module Downloaders
    class FourChan # rubocop:todo Style/Documentation
      include Enumerable

      def download(link)
        img_link = link.attributes['href']
        return unless img_link

        [SecureRandom.uuid + ext(img_link.value), Down.download("https:#{img_link.value}").read]
      end

      def enumerate_link(link)
        html = Nokogiri(Down.download(link).read)

        html.search('a').select { |l| l.children.size == 1 && l.children.first.to_s.match(/.*(jpg|png)$/) }
      end

      def initialize(main_page)
        @main_page = main_page
        @links = enumerate_link(@main_page)
      end

      def ext(link)
        ".#{link.split('.').last}"
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
