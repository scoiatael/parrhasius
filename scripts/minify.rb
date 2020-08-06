# frozen_string_literal: true

require_relative '../lib/parrhasius'

storage = Parrhasius::Storage.new(ARGV.first)

Parrhasius::Dedup.new(db: 'db/index.pstore', dir: storage.dir, progress_bar: ProgressBar).run
Parrhasius::Minify.new(ProgressBar).run(src: storage.dir, dest: storage.dir.sub('original', 'thumbnail'))
