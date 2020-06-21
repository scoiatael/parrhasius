# frozen_string_literal: true

module Parrhasius
  class ImageServer
    class Page
      attr_reader :start, :end

      def initialize(size:, current:, total:)
        @current = current
        @size = size
        @start = current * size
        @end = @start + size
        @has_next = total > @end
      end

      def to_h
        {
          number: @current,
          has_next: @has_next,
          next: @has_next ? @current + 1 : nil
        }
      end
    end
  end
end
