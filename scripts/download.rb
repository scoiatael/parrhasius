# frozen_string_literal: true

require_relative '../lib/parrhasius'

def downloader(source)
  case source
  when /4chan/
    Parrhasius::Downloaders::FourChan
  when /soup/
    Parrhasius::Downloaders::Soup
  when /joemonster/
    Parrhasius::Downloaders::Joemonster
  else
    raise StandardError, "unexpected source: #{source}"
  end
end

links = ARGV
storage = Parrhasius::Storage.new(['db', Time.now.to_i, 'original'].join('/'))

links.group_by { |l| downloader(l) }.each do |dw, dw_links|
  Parrhasius::Download.new(dw, storage).run(*dw_links)
end
Parrhasius::Dedup.new(db: 'db/index.pstore', dir: storage.dir).run
Parrhasius::Minify.new.run(src: storage.dir, dest: storage.dir.sub('original', 'thumbnail'))
