class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.string :full_name
      t.string :email
      t.string :message
      t.integer :user_id
      t.timestamps
    end
  end
end
