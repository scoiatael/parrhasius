# frozen_string_literal: true

require_relative '../lib/parrhasius'

storage = Parrhasius::Storage.new(ARGV.first)
index = File.expand_path("#{ENV.fetch('SERVE', './db')}/index.pstore")

Parrhasius::Dedup.new(db: index, dir: storage.dir, progress_bar: ProgressBar).run
Parrhasius::Minify.new(ProgressBar).run(src: storage.dir, dest: storage.dir.sub('original', 'thumbnail'))
