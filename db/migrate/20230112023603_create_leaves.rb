class CreateLeaves < ActiveRecord::Migration[7.0]
  def change
    create_table :leaves do |t|
      t.belongs_to :employee
      t.belongs_to :manager, foreign_key: { to_table: :employees }
      t.belongs_to :leave_type
      t.string :public_id, null: false, limit: 19
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :note, limit: 100
      t.decimal :number_of_days, precision: 4, scale: 2, null: false
      t.boolean :half_day, default: false
      t.string :half_day_time
      t.integer :approval_status, null: false
      t.datetime :approval_date
      t.string :comment, limit: 100
      t.integer :year

      t.timestamps
    end
    add_index :leaves, :year
  end
end
