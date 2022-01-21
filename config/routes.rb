Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post '/api/download', to: 'commands#download'
  get '/api/job/:job_id', to: 'queries#job_status', as: 'job_status'
  get '/api/folders', to: 'queries#folders'
  get '/api/folder/:folder_id/images', to: 'queries#folder_images'
  get '/api/folder/:folder_id/images/:page', to: 'queries#folder_images'
  get '/api/image/:image_id/original', to: 'queries#image_src', as: 'image_src'
  get '/api/image/:image_id/thumbnail', to: 'queries#image_thumbnail', as: 'image_thumbnail'
end
