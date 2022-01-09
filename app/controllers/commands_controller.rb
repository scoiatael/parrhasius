# frozen_string_literal: true

class CommandsController < ApplicationController
  include ActionController::Live

  def download
    payload = JSON.parse(request.body.read)
    path = File.join([DIR, Time.now.to_i.to_s, 'original'])

    DownloadPageJob.perform_later(payload.fetch('url'), path)

    render json: { queued: true }
  end
end
