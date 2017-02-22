class User < ActiveRecord::Base
  has_many :queue_items

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { in: 6..30 }, on: :create
  validates :full_name, presence: true

  has_secure_password validations: false
end
