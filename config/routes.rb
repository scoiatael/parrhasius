# frozen_string_literal: true

# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get '/', to: 'folder#index'
  get '/folders/:folder_id/slideshow', to: 'folder#folder_slideshow'
  get '/liked/slideshow', to: 'folder#liked_slideshow'
  # "static" - to be exposed via nginx
  get '/image/*path.:format', to: 'queries#image', as: :static_image

  # API:
  post '/api/download', to: 'commands#download'
  get '/api/job/:job_id', to: 'queries#job_status', as: 'job_status'
  get '/api/folders', to: 'queries#folders'
  get '/api/folder/:folder_id/images', to: 'queries#folder_images'
  get '/api/folder/:folder_id/images/:page', to: 'queries#folder_images'
  get '/api/folder/:folder_id/bundle', to: 'queries#folder_bundle'
  get '/api/liked_images', to: 'queries#liked_images'
  get '/api/liked_images/:page', to: 'queries#liked_images'

  post '/api/delete_folder', to: 'commands#delete_folder'
  post '/api/merge_folders', to: 'commands#merge_folders'
  post '/api/delete_image', to: 'commands#delete_image'
  post '/api/like_image', to: 'commands#like_image'
end
