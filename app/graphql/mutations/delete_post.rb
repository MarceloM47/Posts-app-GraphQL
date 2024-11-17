module Mutations
    class DeletePost < Mutations::BaseMutation
        description "Delete a post"

        argument :id, ID, required: true, description: "ID for delete the post"
    
        field :success, Boolean, null: false, description: "Indicates if the deletion was successful"
        field :errors, [String], null: false, description: "List of errors if deletion fails"
          
        def resolve(id:)
          post = Post.find_by(id: id)

          if !post || post.account_id != context[:current_account]&.id
            {
              success: false,
              errors: ["Post not found or unauthorized"]
            }
          elsif post.destroy
            {
              success: true,
              errors: []
            }
          else
            {
              success: false,
              errors: post.errors.full_messages
            }
          end
        end    
    end
end
