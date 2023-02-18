module AuthHelper
  def login(account)
    session[:account_id] = account.id
    session[:authenticated_by] = ["password"]
  end

  def logout
    session.clear
  end
end
