class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["myflix", Rails.env].join("_")

  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }
  mount_uploader :large_cover_url, LargeCoverUploader
  mount_uploader :small_cover_url, SmallCoverUploader

  validates :title, :description, presence: true

  def self.search_by_title(term = nil)
    return [] if term.nil? || term.blank?
    Video.where("lower(title) LIKE ?", "%#{term.downcase}%").order("created_at DESC")
  end

  def average_rating
    rating_sum = reviews.map(&:rating).reduce(&:+).to_f
    rating_sum == 0 ? "0" : (rating_sum / reviews.size).to_s
  end

  def in_queue?(user_id)
    QueueItem.find_by(video_id: id, user_id: user_id).present?
  end

  def as_indexed_json(options={})
    as_json(
      methods: [:average_rating],
      only: [:title, :description],
      include: {
        reviews: { only: [:content] }
      }
    )
  end

  def self.search(query, options={})
    search_definition = {
      query: {
        bool: {
          must: {
            multi_match: {
              query: query,
              fields: ["title^100", "description^50"],
              operator: "and"
            }
          }
        }
      }
    }

    if query.present? && options[:reviews].present?
      search_definition[:query][:bool][:must][:multi_match][:fields] << "reviews.content"
    end

    if options[:rating_from].present? || options[:rating_to].present?
      search_definition[:query][:bool][:filter] = {
        range: {
          average_rating: {
            gte: (options[:rating_from] if options[:rating_from].present?),
            lte: (options[:rating_to] if options[:rating_to].present?)
          }
        }
      }
    end

    __elasticsearch__.search(search_definition)
  end
end
