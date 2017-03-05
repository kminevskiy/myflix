class User < ActiveRecord::Base
  has_many :queue_items, -> { order :position }
  has_many :reviews
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :leading_relationships, class_name: "Relationship", foreign_key: "leader_id"

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { in: 6..30 }, on: :create
  validates :full_name, presence: true

  has_secure_password validations: false

  def normalize_queue_items_positions
    queue_items.each_with_index do |item, idx|
      item.update_attributes(position: idx + 1)
    end
  end

  def new_relationship?(another_user_id)
    Relationship.find_by(leader_id: another_user_id, follower_id: id).blank?
  end
end
