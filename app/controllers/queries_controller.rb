# frozen_string_literal: true

class QueriesController < ApplicationController
  include ActionController::Live

  def job_status
    job = ActiveJob::Status.get(params.fetch('job_id'))

    return render json: status(job) if job.completed?

    expires_now
    response.headers['Last-Modified'] = Time.now.httpdate

    send_stream(filename: 'status.json', type: 'application/json', disposition: 'inline') do |stream|
      stream.write('{"events":[')
      loop do
        stream.write(JSON.dump(status(job)))
        break if job.completed?

        sleep 0.1
      end
      stream.write(']}')
    end
    puts('Done.')
  end

  private

  def status(job)
    { status: job.to_h }
  end
end
