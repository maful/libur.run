class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :public_id, null: false, limit: 19
      t.string :line_1, null: false
      t.string :line_2
      t.string :country_code, limit: 2, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, limit: 10, null: false
      t.references :addressable, polymorphic: true, null: false, index: { unique: true }

      t.timestamps
    end

    add_index :addresses, :public_id, unique: true
  end
end
