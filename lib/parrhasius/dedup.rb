# frozen_string_literal: true

module Parrhasius
  class Dedup
    def initialize(progress_bar:)
      @pb = PB.new(progress_bar)
    end

    def run(images)
      dups = hash!(images)
      puts "#{dups.size} duplicates found"
      dups.each(&:destroy)
    end

    private

    def hash!(imgs)
      @pb.around(imgs, title: 'Hashing').reject(&:unique?)
    end
  end
end
