Rails.application.routes.draw do
  # GRAPHQL
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"



  get "up" => "rails/health#show", as: :rails_health_check
end
