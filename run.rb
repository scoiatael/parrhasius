# frozen_string_literal: true

require_relative 'lib/parrhasius'

def downloader(source)
  case source
  when '4chan'
    Parrhasius::Downloaders::FourChan
  when 'soup'
    Parrhasius::Downloaders::Soup
  else
    raise StandardError, "unexpected source: #{source}"
  end
end

source = ARGV.first
links = ARGV[1..-1]
storage = Parrhasius::Storage.new(['db', Time.now.to_i, 'original'].join('/'))

Parrhasius::Download.new(downloader(source), storage).run(*links)
Parrhasius::Dedup.new(db: 'db/index.pstore', dir: storage.dir).run
Parrhasius::Minify.new.run(src: storage.dir, dest: storage.dir.sub('original', 'thumbnail'))
