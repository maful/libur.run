class CreateOnboardings < ActiveRecord::Migration[7.0]
  def change
    create_table :onboardings do |t|
      t.belongs_to :employee
      t.integer :state, limit: 1, null: false, default: 0
      t.boolean :subscribe, default: false

      t.timestamps
    end
  end
end
