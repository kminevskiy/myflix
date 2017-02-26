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

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_items_positions
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position numbers."
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.where(user: current_user, id: params[:id]).first
    queue_item.destroy if queue_item.present?
    current_user.normalize_queue_items_positions
    redirect_to my_queue_path
  end

  private

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |data|
        queue_item = QueueItem.find(data[:id])
        queue_item.update_attributes!(position: data[:position], rating: data[:rating]) if queue_item.user == current_user
      end
    end
  end
end
