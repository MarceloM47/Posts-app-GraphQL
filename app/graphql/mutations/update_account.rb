module Mutations
    class UpdateAccount < Mutations::BaseMutation
      description "Update account information"

      argument :id, ID, required: true,
        description: "ID of the account to update"
      argument :name, String, required: false,
        description: "New name for the account"
      argument :account_type, Types::AccountTypeType, required: false,
        description: "New account type"
      argument :company_number, String, required: false,
        description: "New company number"
      argument :date_of_birth, GraphQL::Types::ISO8601Date, required: false,
        description: "New date of birth"
      argument :email, String, required: false,
        description: "New email address"
  
      field :account, Types::AccountType, null: true,
        description: "The updated account"
      field :errors, [String], null: false,
        description: "List of errors if update fails"
  
      def resolve(id:, **args)
        account = Account.find_by(id: id)
  
        unless account && account.id == context[:current_account]&.id
          return {
            account: nil,
            errors: ["Account not found or unauthorized"]
          }
        end
  
        if account.update(args)
          {
            account: account,
            errors: []
          }
        else
          {
            account: nil,
            errors: account.errors.full_messages
          }
        end
      end
    end
end
