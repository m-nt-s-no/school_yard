class AddDefaultToCountsInUserModel < ActiveRecord::Migration[7.1]
  def change
    change_column_default(
      :users,
      :enrollments_count,
      0
    )
    change_column_default(
      :users,
      :received_messages_count,
      0
    )
    change_column_default(
      :users,
      :sent_messages_count,
      0
    )
  end
end
