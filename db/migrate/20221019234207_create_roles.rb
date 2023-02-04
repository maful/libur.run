class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :public_id, null: false, limit: 19

      t.timestamps
    end
    add_index :roles, :name, unique: true
    add_index :roles, :public_id, unique: true
  end
end
