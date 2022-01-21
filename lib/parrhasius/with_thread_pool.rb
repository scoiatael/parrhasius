module Parrhasius
  class WithThreadPool
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
