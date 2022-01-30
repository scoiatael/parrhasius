# frozen_string_literal: true

module Parrhasius
  class ActiveJobPB # rubocop:todo Style/Documentation
    def initialize(job)
      @job = job
    end

    def create(title:, total:, format:) # rubocop:todo Lint/UnusedMethodArgument
      @job.status.update(step: title, total: total, progress: 0)
      self
    end

    def increment
      @job.progress.increment
    end

    def finish; end
  end
end
