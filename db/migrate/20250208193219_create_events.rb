class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      enable_extension("citext")
      t.citext :name, null: false, default: ""
      t.references :group, null: false, foreign_key: true
      t.datetime :starts_at
      t.string :address
      t.text :notes
      t.datetime :ends_at

      t.timestamps
    end
  end
end
