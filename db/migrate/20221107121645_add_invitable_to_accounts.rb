class AddInvitableToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :invitation_token, :string
    add_column :accounts, :invitation_created_at, :datetime
    add_column :accounts, :invitation_sent_at, :datetime
    add_column :accounts, :invitation_accepted_at, :datetime
  end
end
