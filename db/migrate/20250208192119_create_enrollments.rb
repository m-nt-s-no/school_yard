class CreateEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :enrollments do |t|
      t.integer :group_id
      t.integer :user_id

      t.timestamps
    end
  end
end
