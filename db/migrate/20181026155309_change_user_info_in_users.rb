class ChangeUserInfoInUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :nickname, :string
    remove_column :users, :image, :string
    change_column_null :users, :name, false
    add_index :users, :name, unique: true
  end
end
