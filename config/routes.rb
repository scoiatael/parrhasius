Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post '/api/download', to: 'commands#download'
  get '/api/job/:job_id', to: 'queries#job_status', as: 'job_status'
  get '/api/folders', to: 'queries#folders'
  get '/api/folder/:folder_id/images', to: 'queries#folder_images'
  get '/api/folder/:folder_id/images/:page', to: 'queries#folder_images'
  get '/api/folder/:folder_id/bundle', to: 'queries#folder_bundle'

  post '/api/delete_folder', to: 'commands#delete_folder'
  post '/api/merge_folders', to: 'commands#merge_folders'
  post '/api/delete_image', to: 'commands#delete_image'
end
