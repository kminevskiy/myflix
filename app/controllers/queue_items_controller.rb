class QueueItemsController < ApplicationController
  before_action :redirect_to_sign_in

  def index
    @queue_items = current_user.queue_items
    @queue_item = QueueItem.new
  end

  def create
    video = Video.find(params[:video_id])
    QueueItem.create(user: current_user, video: video, position: new_queue_item_position)

    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.where(user: current_user, id: params[:id])
    queue_item.destroy if queue_item.present?
    redirect_to my_queue_path
  end

  private

  def new_queue_item_position
    current_user.queue_items.count + 1
  end
end
