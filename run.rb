# frozen_string_literal: true

require 'ruby-progressbar'
require 'fileutils'

require_relative 'lib/parrhasius'

def downloader(source)
  case source
  when '4chan'
    Downloaders::FourChan
  when 'soup'
    Downloaders::Soup
  else
    raise StandardError, "unexpected source: #{source}"
  end
end

source = ARGV.first
links = ARGV[1..-1]
dest = ['db', Time.now.to_i].join('/')

Parrhasius::Download.new(downloader(source)).run(*links)
