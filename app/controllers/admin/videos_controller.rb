class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    @video.category_id = params[:video][:category]
    if @video.save
      redirect_to videos_path
    else
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :large_cover_url, :small_cover_url)
  end
end
