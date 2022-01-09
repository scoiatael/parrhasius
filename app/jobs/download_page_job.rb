class DownloadPageJob < ApplicationJob
  queue_as :default

  def perform(url, path)
    do_download(url, storage(path))
  end

  private

  def storage(path)
    Parrhasius::Storage.new(path)
  end

  def do_download(url, storage)
    Parrhasius::Download.new(Parrhasius::Download.for(url), storage, ProgressBar).run(url)
    Parrhasius::Dedup.new(db: "#{DIR}/index.pstore",
                          dir: storage.dir,
                          progress_bar: ProgressBar).run
    Parrhasius::Minify.new(ProgressBar).run(src: storage.dir)
    SERVE.refresh!
  end
end
