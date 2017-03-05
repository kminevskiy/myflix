class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_uniqueness_of :video, scope: :user_id

  validates :position, numericality: { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review.present?
      if new_rating.present?
        review_comment = review.stub_comment_present? ? add_stub_comment(new_rating) : review.content
        review.update_column(:rating, new_rating)
        review.update_column(:content, review_comment)
      else
        review.destroy
      end
    else
      review = Review.new(content: add_stub_comment(new_rating), rating: new_rating, user: user, video_id: video_id)
      review.save(validate: false)
    end

  end

  def category_name
    category.name
  end

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end

  def add_stub_comment(rating)
    case rating.to_i
    when 5 then "An excellent movie"
    when 4 then "A good movie"
    when 3 then "An average movie"
    when 2 then "A bad movie"
    when 1 then "A horrible movie"
    end
  end
end
