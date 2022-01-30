# frozen_string_literal: true

module Parrhasius
  class WithThreadPool # rubocop:todo Style/Documentation
    def initialize(**vars)
      @wrapped = {}
      vars.each do |name, val|
        @wrapped[name] = Concurrent::MVar.new(val)
      end
    end

    def run(*args, &block)
      pool = Concurrent::FixedThreadPool.new(Concurrent.processor_count)
      vs = block.call(pool, *args, **@wrapped)
      pool.shutdown
      pool.wait_for_termination
      vs
    end
  end
end
