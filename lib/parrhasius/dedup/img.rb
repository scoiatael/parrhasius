# frozen_string_literal: true

module Parrhasius
  class Dedup
    class Img
      attr_reader :hash, :path

      def initialize(path)
        @path = path
      end

      def hash!
        @hash = do_hash(path)
      end

      private

      def do_hash(file)
        Parrhasius::Hash.call(file.to_s).strip
      end
    end
  end
end
