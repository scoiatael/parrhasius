# frozen_string_literal: true

require 'down'
require 'nokogiri'
require 'securerandom'

module Parrhasius
  module Downloaders
    class Generic
      include Enumerable

      def download(img_link)
        [SecureRandom.uuid + ext(img_link), Down.download(img_link).read]
      end

      def enumerate_link(link)
        html = Nokogiri(Down.download(link).read)

        html.search('a img').map(&:parent).map { |x| link(x) }.reject(&:nil?)
      end

      def initialize(main_page)
        @main_page = main_page
        @links = enumerate_link(@main_page)
      end

      def ext(link)
        '.' + link.split('.').last
      end

      def each(&block)
        @links.each(&block)
      end

      def total
        @links.size
      end

      private

      def link(a)
        img_link = a.attributes['href']
        return unless img_link

        v = img_link.value
        return v if v.match(/.*(jpg|png)$/)

        nil
      end
    end
  end
end
