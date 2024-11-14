# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include Queries::AccountQueries
    include Queries::PostQueries

    # Accounts
    field :account, Types::AccountType, null: true do
      argument :id, ID, required: true
    end

    field :accounts, [Types::AccountType], null: true

    # Posts
    field :posts, Types::PostsPageType, null: false do
      argument :page, Integer, required: false, default_value: 1
      argument :per_page, Integer, required: false, default_value: 10
    end

    def posts(page:, per_page:)
      total = Post.count
      {
        items: Post.offset((page - 1) * per_page).limit(per_page),
        total_count: total,
        total_pages: (total.to_f / per_page).ceil,
        current_page: page
      }
    end

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
  end
end
