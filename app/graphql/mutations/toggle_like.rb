module Mutations
  class ToggleLike < Mutations::BaseMutation
    description "Toggle like on a post"

    argument :post_id, ID, required: true, description: "ID of the post to like/unlike"

    field :success, Boolean, null: false
    field :post, Types::Posts::PostType, null: true
    field :errors, [String], null: false

    def resolve(post_id:)
      post = Post.find_by(id: post_id)
      return { success: false, errors: ["Post not found"], post: nil } unless post

      unless context[:current_account]
        return { success: false, errors: ["Must be logged in to like posts"], post: nil }
      end

      existing_reaction = post.reactions.find_by(account: context[:current_account])

      if existing_reaction
        existing_reaction.destroy
        {
          success: true,
          post: post.reload,
          errors: []
        }
      else
        reaction = post.reactions.create(account: context[:current_account])
        
        if reaction.persisted?
          {
            success: true,
            post: post.reload,
            errors: []
          }
        else
          {
            success: false,
            post: post,
            errors: reaction.errors.full_messages
          }
        end
      end
    rescue => e
      {
        success: false,
        post: nil,
        errors: ["An error occurred: #{e.message}"]
      }
    end
  end
end
