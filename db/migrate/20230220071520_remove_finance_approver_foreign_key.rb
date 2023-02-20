class RemoveFinanceApproverForeignKey < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :companies, to_table: :employees, column: :finance_approver_id
  end
end
