module Mutations
  class Login < Mutations::BaseMutation
    field :account, Types::AccountType, null: true, description: "Login a user."
    field :token, String, null: true
    field :errors, [String], null: true

    argument :email, String, required: true, description: "Email of the user."
    argument :password, String, required: true, description: "Password of the user."

    def resolve(email:, password:)
      account = Account.find_by(email: email)

      if account&.authenticate(password)
        token = JsonWebToken.encode(user_id: account.id)
        { account: account, token: token }
      else
        { errors: ['Invalid credentials'] }
      end
    rescue => e
      { errors: [e.message] }
    end
  end
end
