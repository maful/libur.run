class AddInvitationTokenIndexToAccounts < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :accounts, :invitation_token, unique: true, algorithm: :concurrently
  end
end
