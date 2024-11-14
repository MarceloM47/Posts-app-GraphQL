module Mutations
    class CreatePost < Mutations::BaseMutation
      field :post, Types::PostType, null: true
      field :errors, [String], null: false
  
      argument :title, String, required: true
      argument :content, String, required: true
  
      def resolve(title:, content:)
        account = context[:current_account]
        
        post = account.posts.build(
          title: title,
          content: content
        )
  
        if post.save
          {
            post: post,
            errors: []
          }
        else
          {
            post: nil,
            errors: post.errors.full_messages
          }
        end
      end
    end
end
