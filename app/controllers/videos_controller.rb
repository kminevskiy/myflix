class VideosController < ApplicationController
  before_action :redirect_to_sign_in

  def index
    @categories = Category.all.reject { |category| category.videos.empty? }
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id]).decorate
    @review = Review.new
    @reviews = @video.reviews
  end

  def search
    @videos = Video.search_by_title(params[:query])
  end

  def advanced_search
    options = {
      reviews: params[:reviews],
      rating_from: params[:rating_from],
      rating_to: params[:rating_to]
    }

    if params[:query]
      @videos = Video.search(params[:query], options).records.to_a
    else
      @videos = []
    end
  end
end
