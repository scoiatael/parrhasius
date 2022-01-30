# frozen_string_literal: true

require 'down'
require 'nokogiri'
require 'securerandom'

module Parrhasius
  module Downloaders
    class Joemonster # rubocop:todo Style/Documentation
      include Enumerable

      def download(img)
        src = img['src']
        [SecureRandom.uuid + ext(src), Down.download(src).read]
      end

      def enumerate_link(link)
        html = Nokogiri(Down.download(link).read)

        html.search('#arcik img').select { |l| l['src'].match(/.*(jpg|png)$/) }
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
