class Post < ApplicationRecord
  has_many :comments

  def self.serwis(page, per_page)
    per_page = 100 if per_page > 100

    posts = self.where.not(published_at: nil)
                .order(published_at: :DESC)
                .offset(page * per_page)
                .limit(per_page)

    posts_with_comments = posts.map { |p| { p => p.comments } }
  end
end

