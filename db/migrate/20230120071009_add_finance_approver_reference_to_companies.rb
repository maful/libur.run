class AddFinanceApproverReferenceToCompanies < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :companies, :finance_approver, index: { algorithm: :concurrently }
  end
end
