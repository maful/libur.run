class CreateClaimGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_groups do |t|
      t.string :public_id, limit: 19, null: false
      t.string :name, limit: 50, null: false
      t.datetime :submission_date, null: false
      t.integer :approval_status, limit: 1, null: false
      t.datetime :approval_date
      t.string :comment, limit: 100
      t.monetize :total_amount
      t.belongs_to :employee
      t.belongs_to :approver, foreign_key: { to_table: :employees }

      t.timestamps
    end
    add_index :claim_groups, :public_id, unique: true
  end
end
