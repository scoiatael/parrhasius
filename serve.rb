# frozen_string_literal: true

require 'sinatra'

require_relative 'lib/parrhasius/serve'

serve = Parrhasius::Serve.new(File.expand_path(ENV['SERVE'] || './db/staging'))
options = {
  base_path: ''
}

if ENV['APP_ENV'] == 'production'
  set :public_folder, 'ext/gallery/build'

  get '/' do
    redirect '/index.html'
  end
else
  options[:base_path] = 'http://localhost:9393'

  before do
    headers(
      'Access-Control-Allow-Origin' => 'http://localhost:3000'
    )
  end
end

get '/all' do
  page_size = 200
  page_number = Integer(params[:page] || '0')
  page_start = page_number * page_size
  page_end = page_start + page_size
  data = serve.all
  has_next = data.size > page_end
  records = data[page_start...page_end].map do |t|
    {
      src: options[:base_path] + '/image/' + File.basename(t.path),
      width: t.width,
      height: t.height,
      original: options[:base_path] + '/image_full/' + File.basename(t.path)
    }
  end
  JSON.dump(
    records: records,
    page: {
      number: page_number,
      has_next: has_next,
      next: page_number + 1
    }
  )
end

get '/image_full/:id' do |id|
  thumbnail = serve.by_basename(id)
  img = serve.full(thumbnail.path)

  content_type img.mime_type
  File.read(img.path)
end

get '/image/:id' do |id|
  img = serve.by_basename(id)
  content_type img.mime_type
  File.read(img.path)
end
