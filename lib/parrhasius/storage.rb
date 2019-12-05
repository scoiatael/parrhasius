# frozen_string_literal: true

module Parrhasius
  class Storage
    attr_reader :dir

    def initialize(dir)
      @dir = dir
      FileUtils.mkdir_p(dir)
    end

    def save(name, bytes)
      open(file(name), 'wb') do |file|
        file << bytes
      end
    end

    def file(name)
      [@dir, name].join('/')
    end
  end
end
