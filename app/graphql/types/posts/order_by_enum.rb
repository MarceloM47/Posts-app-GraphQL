# frozen_string_literal: true

module Types
    module Posts
        class OrderByEnum < Types::BaseEnum
            value "CREATED_AT_ASC", "Order by created_at in ascending order"
            value "CREATED_AT_DESC", "Order by created_at in descending order"
            value "UPDATED_AT_ASC", "Order by updated_at in ascending order"
            value "UPDATED_AT_DESC", "Order by updated_at in descending order"
        end
    end
end
