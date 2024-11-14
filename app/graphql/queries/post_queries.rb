# frozen_string_literal: true

module Queries
  module PostQueries
    def post(id:)
      Post.find_by(id: id)
    end

    def posts(page: 1, per_page: 10)
      Post.offset((page - 1) * per_page).limit(per_page)
    end
  end
end
