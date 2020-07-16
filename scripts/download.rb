# frozen_string_literal: true

require_relative '../lib/parrhasius'

links = ARGV
storage = Parrhasius::Storage.new(['db', Time.now.to_i, 'original'].join('/'))

links.group_by { |l| Parrhasius::Download.for(l) }.each do |dw, dw_links|
  Parrhasius::Download.new(dw, storage, ProgressBar).run(*dw_links)
end
Parrhasius::Dedup.new(db: 'db/index.pstore', dir: storage.dir, progress_bar: ProgressBar).run
Parrhasius::Minify.new(ProgressBar).run(src: storage.dir, dest: storage.dir.sub('original', 'thumbnail'))
