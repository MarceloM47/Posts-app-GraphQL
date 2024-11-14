# frozen_string_literal: true

module Queries
    module PostQueries
      def post(id:)
        Post.find_by(id: id)
      end
  
      def posts
        Post.all
      end
    end
end
