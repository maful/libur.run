class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :public_id, null: false, limit: 19
      t.string :name, null: false
      t.string :position
      t.date :start_date
      t.integer :status, limit: 1, default: 0
      t.integer :marital_status, limit: 1
      t.integer :religion, limit: 1
      t.string :citizenship, limit: 2
      t.string :identity_number
      t.string :passport_number
      t.date :birthday
      t.string :phone_number
      t.string :country_of_work, limit: 2
      t.belongs_to :account, foreign_key: true
      t.belongs_to :manager, foreign_key: { to_table: :employees }

      t.timestamps
    end
    add_index :employees, :public_id, unique: true
  end
end
