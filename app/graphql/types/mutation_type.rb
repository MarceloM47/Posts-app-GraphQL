# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Accounts
    field :login, mutation: Mutations::Login
    field :register, mutation: Mutations::Register
    
    # Posts
    field :create_post, mutation: Mutations::CreatePost
  end
end
