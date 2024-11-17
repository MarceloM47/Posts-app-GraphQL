module Mutations
    class UpdatePost < Mutations::BaseMutation
        description "Update a post"

        argument :id, ID, required: true, description: "ID for update the post"
        argument :title, String, required: true, description: "New Title for the post"
        argument :content, String, required: true, description: "New Content for the post"
    
        field :post, Types::Posts::PostType, null: true, description: "Update the post"
        field :errors, [String], null: false, description: "List of errors"
  
          
        def resolve(id:, title:, content:)
            post = Post.find_by(id: id)
      
            unless post && post.account_id == context[:current_account]&.id
              return {
                post: nil,
                errors: ["Post not found or unauthorized"]
              }
            end
      
            if post.update(title: title, content: content)
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
