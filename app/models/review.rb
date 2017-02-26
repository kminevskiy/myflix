class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :content, :rating, presence: true

  def stub_comment_present?
    ["An excellent movie", "A good movie",
     "An average movie", "A bad movie",
     "A horrible movie"].include?(content)
  end
end
