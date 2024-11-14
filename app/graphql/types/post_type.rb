# frozen_string_literal: true

module Types
    class PostType < Types::BaseObject
      field :id, ID, null: false
      field :title, String, null: false
      field :content, String, null: false
      field :account, Types::AccountType, null: false
      field :created_at, GraphQL::Types::ISO8601Date, null: false
      field :updated_at, GraphQL::Types::ISO8601Date, null: false
    end
end
