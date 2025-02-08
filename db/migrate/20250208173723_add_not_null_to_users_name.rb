class AddNotNullToUsersName < ActiveRecord::Migration[7.1]
  def change_column_null
    :users,
    :name,
    false
  end
end
