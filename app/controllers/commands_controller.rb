# frozen_string_literal: true

class CommandsController < ApplicationController
  include ActionController::Live

  def download
    payload = JSON.parse(request.body.read)

    do_download payload.fetch('url'),
                storage

    render json: { done: true }
  end

  private

  def storage
    Parrhasius::Storage.new([DIR, Time.now.to_i, 'original'].join('/'))
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
