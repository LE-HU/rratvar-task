class GetPaginatedPostsService
  def initialize(post_model: Post, page:, limit:)
    @post_model = post_model
    @page = page
    limit > 100 ? @limit = 100 : @limit = limit
  end

  def call
    posts_hash
  end

  private

  attr_reader :post_model, :page, :limit

  def posts_hash
    posts.map do |post|
      {
        id: post.id,
        title: post.title,
        body: post.body,
        comments: comments_hash(post)
      }
    end
  end

  def comments_hash(given_post)
    given_post.comments.each do |comment|
      {
        id: comment.id,
        body: comment.body,
        name: comment.author&.first_name
      }
    end
  end

  def posts
    post_model.where.not(published_at: nil)
              .order(published_at: :DESC)
              .offset(page * limit)
              .limit(limit)
  end
end
