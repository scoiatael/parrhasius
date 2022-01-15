# frozen_string_literal: true

class CommandsController < ApplicationController
  include ActionController::MimeResponds

  def download
    payload = JSON.parse(request.body.read)
    path = File.join([DIR, Time.now.to_i.to_s, 'original'])

    job = DownloadPageJob.perform_later(payload.fetch('url'), path)

    respond_to do |format|
      format.html { redirect_to job_status_url(job.job_id) }
      format.json { render json: { queued: true, job_id: job.job_id } }
    end
  end
end
