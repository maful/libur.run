# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def invite
    UserMailer.with(profile_id: 23).invite
  end
end
