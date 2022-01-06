module Parrhasius
  class StreamingProgressBar
    def initialize(stage, stream)
      @stage = stage
      @stream = stream
      @title = nil
      @total = nil
      @progress = nil
    end

    def create(title:, total:, **_opts)
      @title = title
      @total = total
      @progress = 0
      out(:start)
      self
    end

    def increment
      @progress += 1
      out(:increment)
    end

    def finish
      out(:done)
    end

    private

    def out(status)
      @stream << "#{JSON.dump(stage: @stage, status: status, progress: @progress, total: @total, title: @title)},"
    end
  end
end
