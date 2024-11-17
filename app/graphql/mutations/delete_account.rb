module Mutations
    class DeleteAccount < Mutations::BaseMutation
        description "Delete an account"

        argument :id, ID, required: true, description: "ID of the account to delete"
    
        field :success, Boolean, null: false, description: "Indicates if the deletion was successful"
        field :errors, [String], null: false, description: "List of errors if deletion fails"
          
        def resolve(id:)
          account = Account.find_by(id: id)

          unless account && account.id == context[:current_account]&.id
            return {
              success: false,
              errors: ["Account not found or unauthorized"]
            }
          end
    
          if account.destroy
            {
              success: true,
              errors: []
            }
          else
            {
              success: false,
              errors: account.errors.full_messages
            }
          end    
        end    
    end
end
