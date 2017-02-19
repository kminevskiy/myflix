class ChangeUserColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :lname
    rename_column :users, :fname, :full_name
  end
end
