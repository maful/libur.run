module FeatureHelpers
  def login(account)
    page.set_rack_session(account_id: account.id)
    page.set_rack_session(authenticated_by: "password")
  end

  def logout
    page.set_rack_session(account_id: nil)
    page.set_rack_session(authenticated_by: nil)
  end
end
