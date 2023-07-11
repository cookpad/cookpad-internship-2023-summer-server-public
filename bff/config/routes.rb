Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  mount GraphqlPlayground::Rails::Engine, at: '/', graphql_path: '/graphql'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/hello/revision' => RevisionPlate::App.new
end
