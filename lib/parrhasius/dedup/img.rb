# frozen_string_literal: true

module Parrhasius
  module Dedup
    class Img
      BIN = '~/go/bin/parrhasius'

      attr_reader :hash, :path

      def initialize(path)
        @path = path
      end

      def hash!
        @hash = do_hash(path)
      end

      private

      def do_hash(file)
        `#{BIN} -filename=#{file}`.strip
      end
    end
  end
end
