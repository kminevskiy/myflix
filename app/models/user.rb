class User < ActiveRecord::Base
  has_many :queue_items, -> { order :position }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { in: 6..30 }, on: :create
  validates :full_name, presence: true

  has_secure_password validations: false

  def normalize_queue_items_positions
    queue_items.each_with_index do |item, idx|
      item.update_attributes(position: idx + 1)
    end
  end
end
