# frozen_string_literal: true

module Types
  module Posts
    class PostType < Types::BaseObject
      field :id, ID, null: false
      field :title, String, null: false
      field :content, String, null: false
      field :account, Types::AccountType, null: false

      field :likes_count, Integer, null: false, description: "Number of likes on this post"
      field :liked_by_current_user, Boolean, null: false, description: "Whether the current user has liked this post"

      def likes_count
        object.reactions.count
      end
  
      def liked_by_current_user
        return false unless context[:current_account]
        object.reactions.exists?(account: context[:current_account])
      end  
      
      field :created_at, GraphQL::Types::ISO8601Date, null: false
      field :updated_at, GraphQL::Types::ISO8601Date, null: false
    end
  end
end
