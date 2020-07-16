# frozen_string_literal: true

module Parrhasius
  class PB
    class Enum
      include Enumerable

      def initialize(pb, arr)
        @pb = pb
        @arr = arr
      end

      def each(&block)
        @arr.each do |a|
          block.call(a)
          @pb.increment
        end

        @pb.finish
      end
    end

    def initialize(progress_bar)
      @color = 32
      @progress_bar = progress_bar
    end

    def create(**opts)
      @progress_bar.create(format: format, **opts)
    end

    def around(arr, **opts)
      Enum.new(create(total: arr.size, **opts), arr)
    end

    def format
      "%t (%c/%C): |\e[0;#{@color += 1}m%B\e[0m| %E"
    end
  end
end
