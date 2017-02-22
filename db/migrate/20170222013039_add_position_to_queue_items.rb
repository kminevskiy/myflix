class AddPositionToQueueItems < ActiveRecord::Migration[5.0]
  def change
    add_column :queue_items, :position, :integer
  end
end
