class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.integer :leader_id
      t.integer :follower_id
      t.timestamps
    end
  end
end
