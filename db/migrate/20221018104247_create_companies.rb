class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :public_id, null: false, limit: 19
      t.string :name, null: false
      t.string :website
      t.string :email, null: false
      t.string :phone

      t.timestamps
    end
    add_index :companies, :public_id, unique: true
    add_index :companies, :email, unique: true
  end
end
