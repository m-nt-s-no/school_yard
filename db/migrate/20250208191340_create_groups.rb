class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups do |t|
      enable_extension("citext")
      t.citext :name
      t.references :leader, null: false, foreign_key: { to_table: :users }
      t.integer :enrollments_count, default: 0

      t.timestamps
    end
  end
end
