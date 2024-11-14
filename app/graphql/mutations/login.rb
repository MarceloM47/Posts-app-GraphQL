module Mutations
    class Login < Mutations::BaseMutation
        field :account, Types::AccountType, null: false, description: "Login a user."

        argument :email, String, required: true, description: "Email of the user."
        argument :password, String, required: true, description: "Password of the user."    

        def resolve(email:, password:)
          account = Account.find_by(email: email)
          if account&.authenticate(password)
            { account: account }
          else
            raise GraphQL::ExecutionError, "Invalid email or password"
          end
        end    
    end
end
