# frozen_string_literal: true

module Types
    module Posts
        class PostsPageType < Types::BaseObject
            field :results, [Types::Posts::PostType], null: false
            field :total_count, Integer, null: false
            field :total_pages, Integer, null: false
            field :current_page, Integer, null: false
        end
    end
end
