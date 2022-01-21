# frozen_string_literal: true

class QueriesController < ApplicationController
  include ActionController::Live

  def job_status
    job = ActiveJob::Status.get(params.fetch('job_id'))

    return render json: { events: [status(job)] } if job.completed? || job.failed?

    expires_now
    response.headers['Last-Modified'] = Time.now.httpdate

    send_stream(filename: 'status.json', type: 'application/json', disposition: 'inline') do |stream|
      stream.write('{"events":[')
      loop do
        stream.write(JSON.dump(status(job)))
        break if job.completed? || job.failed?

        sleep 0.1
      end
      stream.write(']}')
    end
  end

  def folders
    fs = Folder.all.map { |f| [f.id, { name: f.name, avatar: image_thumbnail_url(f.images.first&.id) }] }.to_h

    render json: { folders: fs }
  end

  def folder_images
    folder = Folder.find(params.fetch('folder_id'))
    page = params.fetch('page', '1').to_i
    images = folder.images.order(:created_at).page(page)
    render json: { records: images.map(&method(:serialize_image)), has_next: !images.empty? && !images.last_page? }
  end

  def image_src
    image = Image.find(params.fetch('image_id'))

    send_file image.path,
              disposition: 'inline',
              filename: File.basename(image.path)
  end

  def image_thumbnail
    image = Image.find(params.fetch('image_id'))

    send_file image.path.sub('original', 'thumbnail'), # TODO: Create model for thumbnail
              filename: File.basename(image.path),
              disposition: 'inline'
  end

  private

  def serialize_image(i)
    {
      id: i.id,
      title: File.basename(i.path),
      width: i.width,
      height: i.height,
      src: image_thumbnail_url(i.id),
      original: image_src_url(i.id)
    }
  end

  def status(job)
    { status: job.to_h }
  end
end
