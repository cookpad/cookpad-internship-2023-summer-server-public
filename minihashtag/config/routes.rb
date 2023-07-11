Rails.application.routes.draw do
  resources :recipe_hashtags, only: [:index]
  resources :hashtags, only: [:create]

  get '/hello/revision' => RevisionPlate::App.new
end
