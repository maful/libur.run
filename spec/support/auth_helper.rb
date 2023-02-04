module AuthHelper
  def login(account, onboarding_completed: true)
    session[:account_id] = account.id
    session[:authenticated_by] = ["password"]
    session[:onboarding_status] = onboarding_completed
  end

  def logout
    session.clear
  end
end
