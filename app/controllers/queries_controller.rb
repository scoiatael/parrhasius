# frozen_string_literal: true

require 'zip'

class QueriesController < ApplicationController # rubocop:todo Style/Documentation
  include ActionController::Live

  def job_status # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    job = ActiveJob::Status.get(params.fetch('job_id'))

    return render json: { events: [status(job)] } if job.completed? || job.failed?

    expires_now
    response.headers['Last-Modified'] = Time.now.httpdate

    send_stream(filename: 'status.json', type: 'application/json', disposition: 'inline') do |stream|
      stream.write("{\"events\":[\n")
      loop do
        stream.write("#{JSON.dump(status(job))},\n")
        break if job.completed? || job.failed?

        sleep 0.1
      end
      stream.write("#{JSON.dump(status(job))}]}")
    end
  end

  def folders
    fs = Folder.eager_load(:thumbnail).all
    json = fs.to_h { |f| [f.id, { name: f.name, avatar: image_url(f.avatar!) }] }
    render json: { folders: json }
  end

  def folder_images # rubocop:todo Metrics/AbcSize
    folder = Folder.find(params.fetch('folder_id'))
    page = params.fetch('page', '1').to_i
    images = folder.images.eager_load(:thumbnail).order(:created_at).page(page)
    has_next = !images.empty? && !images.last_page?
    next_page = has_next ? page + 1 : nil
    render json: { records: images.map(&method(:serialize_image)), page: { has_next: has_next, next: next_page } }
  end

  def liked_images
    page = params.fetch('page', '1').to_i
    images = Image.where(liked: true).eager_load(:thumbnail).order(:created_at).page(page)
    has_next = !images.empty? && !images.last_page?
    next_page = has_next ? page + 1 : nil
    render json: { records: images.map(&method(:serialize_image)), page: { has_next: has_next, next: next_page } }
  end

  def folder_bundle # rubocop:todo Metrics/AbcSize
    folder = Folder.find(params.fetch('folder_id'))

    tmp = Tempfile.new([folder.name, '.zip'], '/tmp')
    Zip::OutputStream.open(tmp.path) do |z|
      folder.images.each do |image|
        z.put_next_entry(File.basename(image.path))
        z.print(File.read(image.path))
      end
    end
    tmp.close

    send_file tmp.path
  end

  def image
    path = File.expand_path("#{params.fetch('path')}.#{params.fetch('format')}", Parrhasius::DIR)
    return 403 unless path.starts_with?(::Parrhasius::DIR)

    send_file path
  end

  private

  def serialize_image(i) # rubocop:todo Naming/MethodParameterName
    {
      id: i.id,
      title: File.basename(i.path),
      width: i.width,
      height: i.height,
      src: image_url(i.thumbnail),
      original: image_url(i),
      liked: i.liked?
    }
  end

  def image_url(image)
    path = Pathname.new(image.path)
    rel = path.relative? ? path.to_s : path.relative_path_from(Parrhasius::DIR).to_s
    request.base_url + "/image/#{rel}"
  end

  def status(job)
    { status: job.to_h }
  end
end
