# frozen_string_literal: true

require 'down'
require 'nokogiri'
require 'fileutils'
require 'net/http'
require 'faraday_middleware'
require 'faraday-cookie_jar'

module Parrhasius
  module Downloaders
    MAX_ITERATIONS = 20
    MAX_REDIRECTS = 6

    class Soup
      include Enumerable
      
      def download(link)
        img_link = link.attributes['href']
        return unless img_link

        [img_link.to_s.split('/').last, Down.download(img_link).read]
      end

      def enumerate_link(base_link)
        links = []
        link = base_link
        iterations = 0
        pb = ProgressBar.create(title: 'Collecting links', total: MAX_ITERATIONS, format: "%t (%c/%C): |\e[0;37m%B\e[0m| %E")
        MAX_ITERATIONS.times do
          break unless links.size < 200

          html = Nokogiri(fetch_with_redirect(link).body)
          links += html.search('a.lightbox').to_a
          next_page = html.search('#load_more a').first
          break unless next_page

          link = base_link + next_page['href']
          iterations += 1
          pb.increment
        end
        pb.finish

        links
      end

      def initialize(main_page)
        @connection = connect!
        @main_page = main_page
        @links = enumerate_link(@main_page)
      end

      def each(&block)
        @links.each(&block)
      end

      def total
        @links.size
      end

      private

      def connect!
        Faraday.new do |builder|
          builder.use :cookie_jar
          builder.adapter Faraday.default_adapter
        end
      end

      def fetch(url, cookies:)
        @connection.get(url, nil, 'Cookie' => cookies)
      end

      def fetch_with_redirect(url, cookies: nil, limit: MAX_REDIRECTS)
        MAX_REDIRECTS.times do
          r = fetch(url, cookies: cookies)
          return r if r.status == 200
          raise StandardError, "Unexpected status #{r.status}" unless r.status == 302

          url = r['Location']
          cookies = r['set-cookie'].sub(',', ';') if r['set-cookie'] # For weird reasons Faraday joins headers with ,
        end
        raise StandardError, "Too many redirects"
      end
    end
  end
end
