# frozen_string_literal: true

module Queries
    module AccountQueries
      def account(id:)
        Account.find_by(id: id)
      end
  
      def accounts
        Account.all
      end
    end
end
