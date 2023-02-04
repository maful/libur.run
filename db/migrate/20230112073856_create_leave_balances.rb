class CreateLeaveBalances < ActiveRecord::Migration[7.0]
  def change
    create_table :leave_balances do |t|
      t.belongs_to :employee
      t.belongs_to :leave_type
      t.decimal :entitled_balance, precision: 4, scale: 2, null: false
      t.decimal :remaining_balance, precision: 4, scale: 2, null: false
      t.integer :year, null: false

      t.timestamps
    end
    add_index :leave_balances, :year
    add_index :leave_balances, [:employee_id, :leave_type_id, :year], unique: true
  end
end
