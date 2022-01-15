class DownloadPageJob < ApplicationJob
  include ActiveJob::Status

  queue_as :default

  def perform(url, path)
    do_download(url, storage(path))
  end

  private

  def storage(path)
    Parrhasius::Storage.new(path)
  end

  def do_download(url, storage)
    pb = Parrhasius::ActiveJobPB.new(self)
    Parrhasius::Download.new(Parrhasius::Download.for(url), storage, pb).run(url)
    Parrhasius::Dedup.new(db: "#{DIR}/index.pstore",
                          dir: storage.dir,
                          progress_bar: pb).run
    Parrhasius::Minify.new(pb).run(src: storage.dir)
    SERVE.refresh!
  end
end
