# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'securerandom'
require 'fileutils'

module Parrhasius
  module Downloaders
    class FourChan
      def save(link)
        open(folder(link), 'wb') do |file|
          file << open('https:' + link).read
        end
      end

      def download(link)
        img_link = link.attributes['href']
        return unless img_link

        save(img_link.value)
      end

      def enumerate_link(link)
        html = Nokogiri(open(link).read)

        html.search('a').select { |l| l.children.size == 1 && l.children.first.to_s.match(/.*(jpg|png)$/) }
      end

      def initialize(main_page)
        @main_page = main_page
        @links = enumerate_link(@main_page)
        FileUtils.mkdir_p('imgs')
      end

      def folder(link)
        ['imgs', SecureRandom.uuid + ext(link)].join('/')
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
    end
  end
end
