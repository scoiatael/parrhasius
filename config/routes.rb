Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post '/api/download', to: 'commands#download'
  get '/api/job/:job_id', to: 'queries#job_status', as: 'job_status'
end
