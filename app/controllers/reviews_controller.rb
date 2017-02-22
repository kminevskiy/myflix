class ReviewsController < ApplicationController
  before_action :redirect_to_sign_in, only: [:create]

  def create
    review = Review.new(review_params)
    video = Video.find(params[:video_id])
    review.user = current_user
    review.video = video

    if review.save
      redirect_to video
    else
      @reviews = video.reviews
      render "videos/show"
    end
  end


  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
