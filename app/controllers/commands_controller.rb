# frozen_string_literal: true

class CommandsController < ApplicationController
  include ActionController::MimeResponds

  def download
    payload = JSON.parse(request.body.read)
    fname = Time.now.to_i.to_s

    job = DownloadPageJob.perform_later(payload.fetch('url'), fname)

    respond_to do |format|
      format.html { redirect_to job_status_url(job.job_id) }
      format.json { render json: { queued: true, job_id: job.job_id } }
    end
  end

  def delete_folder
    folder = Folder.find(JSON.parse(request.body.read).fetch('folder_id'))
    folder.images.each { |i| i.thumbnail.delete unless i.thumbnail.nil? }
    folder.images.delete_all
    folder.delete
    render json: { status: :ok }
  end

  def merge_folders
    payload = JSON.parse(request.body.read)
    src = Folder.find(payload.fetch('src'))
    dst = Folder.find_or_create_by(name: payload.fetch('dst'))
    src.images.each do |image|
      image.folder = dst
      image.save!
    end
    src.delete
    render json: { status: :ok }
  end

  def delete_image
    image = Image.find(JSON.parse(request.body.read).fetch('image_id'))
    image.delete
    render json: { status: :ok }
  end
end
