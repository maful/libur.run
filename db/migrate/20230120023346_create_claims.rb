class CreateClaims < ActiveRecord::Migration[7.0]
  def change
    create_table :claims do |t|
      t.string :public_id, limit: 19, null: false
      t.belongs_to :claim_group
      t.belongs_to :claim_type
      t.belongs_to :employee
      t.date :issue_date, null: false
      t.string :note, limit: 200
      t.monetize :amount

      t.timestamps
    end
    add_index :claims, :public_id, unique: true
  end
end
