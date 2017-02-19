class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, :description, presence: true

  def self.search_by_title(term = nil)
    return [] if term.nil? || term.blank?
    Video.where("lower(title) LIKE ?", "%#{term.downcase}%").order("created_at DESC")
  end
end
