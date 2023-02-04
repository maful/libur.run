class CreateLeaveTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :leave_types do |t|
      t.string :public_id, null: false, limit: 19
      t.string :name, null: false
      t.integer :days_per_year, null: false
      t.integer :year, null: false
      t.boolean :status, default: true

      t.timestamps
    end

    add_index :leave_types, :year
  end
end
