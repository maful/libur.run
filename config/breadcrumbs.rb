crumb :root do
  link "Home", home_path
end

# Users
crumb :users do
  link "Users", users_path
end

crumb :new_user do
  link "Invite User", new_user_path
  parent :users
end

crumb :edit_user do |user|
  link "Update User", edit_user_path(user)
  parent :users
end

# User details
crumb :user do |user|
  link "Details", user_path(user)
  parent :users
end

crumb :leaves do
  link "My Leaves", leaves_path
end

crumb :leaves_summary do
  link "Leave Summary", summary_leaves_path
  parent :leaves
end

crumb :team_leaves do
  link "Team Leave Requests", team_leaves_path
end

crumb :claims do
  link "My Claims", claims_path
end

crumb :team_claims do
  link "Team Claims", team_claims_path
end

# settings
crumb :settings do
  link "Settings", settings_root_path
end

crumb :settings_profile do
  link "My Profile", settings_my_profile_path
  parent :settings
end

crumb :settings_me do
  link "Personal", settings_me_path
  parent :settings
end

crumb :settings_company do
  link "Company", settings_company_path
  parent :settings
end

crumb :settings_password do
  link "Password", settings_password_path
  parent :settings
end

crumb :settings_plan do
  link "Plan", settings_plan_path
  parent :settings
end

crumb :settings_notifications do
  link "Notifications", settings_notifications_path
  parent :settings
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
