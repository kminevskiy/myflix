class CreateQueue < ActiveRecord::Migration[5.0]
  def change
    create_table :queues do |t|
      t.integer :user_id
      t.integer :video_id
      t.timestamps
    end
  end
end
