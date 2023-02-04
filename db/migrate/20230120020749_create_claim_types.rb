class CreateClaimTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_types do |t|
      t.string :public_id, limit: 19, null: false
      t.string :name, limit: 50, null: false
      t.string :description, limit: 100
      t.boolean :status, default: true
      t.integer :year, null: false

      t.timestamps
    end
    add_index :claim_types, :public_id, unique: true
    add_index :claim_types, [:year, :name], unique: true
  end
end
