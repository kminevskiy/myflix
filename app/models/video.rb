class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }

  validates :title, :description, presence: true

  def self.search_by_title(term = nil)
    return [] if term.nil? || term.blank?
    Video.where("lower(title) LIKE ?", "%#{term.downcase}%").order("created_at DESC")
  end

  def average_rating
    rating_sum = self.reviews.map(&:rating).reduce(&:+).to_f
    rating_sum == 0 ? 0 : rating_sum / self.reviews.size
  end

  def in_queue?(user_id)
    QueueItem.find_by(video_id: id, user_id: user_id).present?
  end
end
