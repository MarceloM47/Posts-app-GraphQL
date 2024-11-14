# frozen_string_literal: true

module Queries
  module PostQueries
    def post(id:)
      Post.find_by(id: id)
    end

    def posts(
      order_by: nil,
      page: 1,
      per_page: 10
    ) 
      posts = Post.all

      posts = order_posts(posts, order_by)

      Post.offset((page - 1) * per_page).limit(per_page)
    end
  end
end
