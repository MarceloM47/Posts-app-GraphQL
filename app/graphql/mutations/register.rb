module Mutations
    class Register < Mutations::BaseMutation
        field :account, Types::AccountType, null: false, description: "Register a new user."

        argument :account_type, Types::AccountTypeType, required: true, description: "Type of the account."
        argument :name, String, required: true, description: "Name of the user."
        argument :company_number, String, required: true
        argument :date_of_birth, String, required: true
        argument :email, String, required: true
        argument :password, String, required: true

        def resolve(**args)
            account = Account.new(args)
            if account.save
              { account: account }
            else
              if account.errors.details[:email]&.any? { |error| error[:error] == :taken }
                raise GraphQL::ExecutionError, "The email is already in use."
              elsif account.errors.details[:username]&.any? { |error| error[:error] == :taken }
                raise GraphQL::ExecutionError, "The username is already in use."
              else
                raise GraphQL::ExecutionError, "Register failed: #{account.errors.full_messages.join(', ')}"
              end
            end
        end
    end
end
