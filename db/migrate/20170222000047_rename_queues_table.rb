class RenameQueuesTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :queues, :queue_items
  end
end
