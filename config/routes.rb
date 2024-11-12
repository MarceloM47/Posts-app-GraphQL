Rails.application.routes.draw do
  # GRAPHQL
  post "/graphql", to: "graphql#execute"
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/your/endpoint"
  end



  get "up" => "rails/health#show", as: :rails_health_check
end
