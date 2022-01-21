module Parrhasius
  class ActiveJobPB
    def initialize(job)
      @job = job
    end

    def create(title:, total:, format:)
      @job.status.update(step: title, total: total, progress: 0)
      self
    end

    def increment
      @job.progress.increment
    end

    def finish; end
  end
end
