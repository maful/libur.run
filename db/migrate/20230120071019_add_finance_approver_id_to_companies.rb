class AddFinanceApproverIdToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :companies, :employees, column: :finance_approver_id, on_delete: :nullify, validate: false
  end
end
