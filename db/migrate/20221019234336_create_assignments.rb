class CreateAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :assignments do |t|
      t.belongs_to :employee
      t.belongs_to :role

      t.timestamps
    end
  end
end
