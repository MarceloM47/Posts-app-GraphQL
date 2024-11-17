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
      posts = apply_order(posts, order_by) if order_by
      
      total = posts.count
      {
        results: posts.offset((page - 1) * per_page).limit(per_page),
        total_count: total,
        total_pages: (total.to_f / per_page).ceil,
        current_page: page
      }
    end

    private

    def apply_order(posts, order_by)
      case order_by
      when 'CREATED_AT_ASC'
        posts.order(created_at: :asc)
      when 'CREATED_AT_DESC'
        posts.order(created_at: :desc)
      when 'UPDATED_AT_ASC'
        posts.order(updated_at: :asc)
      when 'UPDATED_AT_DESC'
        posts.order(updated_at: :desc)
      else
        posts
      end
    end
  end
end
