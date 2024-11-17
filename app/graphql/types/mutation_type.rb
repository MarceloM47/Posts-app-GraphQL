# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Accounts
    field :login, mutation: Mutations::Login
    field :register, mutation: Mutations::Register
    field :update_account, mutation: Mutations::UpdateAccount
    field :delete_account, mutation: Mutations::DeleteAccount
    
    # Posts
    field :create_post, mutation: Mutations::CreatePost
    field :update_post, mutation: Mutations::UpdatePost
    field :delete_post, mutation: Mutations::DeletePost
  end
end
