class DownloadPageJob < ApplicationJob
  include ActiveJob::Status

  queue_as :default

  def perform(url, fname)
    do_download(url, **storage!(fname))
  end

  private

  def storage!(fname)
    dir = File.join(Parrhasius::DIR, fname)
    FileUtils.mkdir_p(dir)
    { path: dir, folder: Folder.create!(name: fname) }
  end

  def do_download(url, path:, folder:)
    pb = if Rails.env.development?
           Parrhasius::ActiveJobPB.new(self)
         else
           ProgressBar
         end
    images = Parrhasius::Download.new(Parrhasius::Download.for(url), path, pb).run(url)
    folder.images.create(images.map { |image| { path: image.path, width: image.width, height: image.height } })
    # Parrhasius::Dedup.new(db: "#{DIR}/index.pstore",
    #                       dir: path,
    #                       progress_bar: pb).run
    Parrhasius::Minify.new(pb).run(src: path)
    SERVE.refresh!
  rescue StandardError
    folder.delete
    raise
  end
end
