# frozen_string_literal: true

class RodauthMain < Rodauth::Rails::Auth
  configure do
    # List of authentication features that are loaded.
    enable :verify_account,
      :verify_account_grace_period,
      :login,
      :logout,
      :remember,
      :reset_password,
      :change_password,
      :change_password_notify,
      :change_login,
      :verify_login_change,
      :close_account,
      :internal_request,
      :path_class_methods

    # See the Rodauth documentation for the list of available config options:
    # http://rodauth.jeremyevans.net/documentation.html

    # ==> General
    # The secret key used for hashing public-facing tokens for various features.
    # Defaults to Rails `secret_key_base`, but you can use your own secret key.
    # hmac_secret "40072ba014530b48f2cb3ded3e646d75113ee81f8d363e28ad1a274e04caddff9c2d1b5c1600ee1a6485473100193c8e385eee78e292d5d2d595a5815e3ef338"

    # Specify the controller used for view rendering and CSRF verification.
    rails_controller { RodauthController }

    # Set on Rodauth controller with the title of the current page.
    title_instance_variable :@page_title

    # Store account status in an integer column without foreign key constraint.
    account_status_column :status

    # Store password hash in a column instead of a separate table.
    account_password_hash_column :password_hash

    # Set password when creating account instead of when verifying.
    verify_account_set_password? false

    # Redirect back to originally requested location after authentication.
    login_return_to_requested_location? true
    # two_factor_auth_return_to_requested_location? true # if using MFA

    # Autologin the user after they have reset their password.
    reset_password_autologin? false

    # Delete the account record when the user has closed their account.
    delete_account_on_close? true

    # ==> Emails
    # Use a custom mailer for delivering authentication emails.
    create_reset_password_email do
      RodauthMailer.reset_password(self.class.configuration_name, account_id, reset_password_key_value)
    end
    create_verify_account_email do
      RodauthMailer.verify_account(self.class.configuration_name, account_id, verify_account_key_value)
    end
    create_verify_login_change_email do |_login|
      RodauthMailer.verify_login_change(self.class.configuration_name, account_id, verify_login_change_key_value)
    end
    create_password_changed_email do
      RodauthMailer.password_changed(self.class.configuration_name, account_id)
    end
    # create_email_auth_email do
    #   RodauthMailer.email_auth(self.class.configuration_name, account_id, email_auth_key_value)
    # end
    # create_unlock_account_email do
    #   RodauthMailer.unlock_account(self.class.configuration_name, account_id, unlock_account_key_value)
    # end
    send_email do |email|
      # queue email delivery on the mailer after the transaction commits
      db.after_commit { email.deliver_later }
    end

    # ==> Flash
    # Match flash keys with ones already used in the Rails app.
    # flash_notice_key :success # default is :notice
    # flash_error_key :error # default is :alert

    # Override default flash messages.
    # create_account_notice_flash "Your account has been created. Please verify your account by visiting the confirmation link sent to your email address."
    # require_login_error_flash "Login is required for accessing this page"
    # login_notice_flash nil

    # ==> Validation
    # Override default validation error messages.
    no_matching_login_message "Email address doesn't exist"
    # already_an_account_with_this_login_message "user with this email address already exists"
    # password_too_short_message { "needs to have at least #{password_minimum_length} characters" }
    # login_does_not_meet_requirements_message { "invalid email#{", #{login_requirement_message}" if login_requirement_message}" }

    # Change minimum number of password characters required when creating an account.
    password_minimum_length 8

    # ==> Remember Feature
    # Remember all logged in users.
    # after_login { remember_login }

    # Or only remember users that have ticked a "Remember Me" checkbox on login.
    after_login { remember_login if param_or_nil("remember") }

    # Extend user's remember period when remembered via a cookie
    extend_remember_deadline? true

    # Whether to autologin the user upon successful account creation, true by default unless verifying accounts.
    # create_account_autologin? false

    # ==> Hooks
    before_login_route do
      onboarding = rails_controller_eval { onboarding_complete? }
      company = rails_controller_eval { company_exists? }
      if !onboarding || !company
        rails_controller_instance.redirect_to(rails_routes.installation_index_path)
      end
    end

    after_login do
      employee = Account.find(account_id).employee
      employee.create_activity(
        key: "authentication.login",
        owner: employee,
        recipient: employee,
        params: { ip: request.ip },
      )
    end

    before_logout do
      employee = Account.find(session_value).employee
      employee.create_activity(
        key: "authentication.logout",
        owner: employee,
        recipient: employee,
      )
    end

    # Validate custom fields in the create account form.
    # before_create_account do
    #   throw_error_status(422, "name", "must be present") if param("name").empty?
    # end

    # Perform additional actions after the account is created.
    # after_create_account do
    # end

    # Do additional cleanup after the account is closed.
    # after_close_account do
    #   Employee.find_by!(account_id:).destroy
    # end

    before_verify_account_route do
      if new_key = param_or_nil(verify_account_key_param)
        account_from_verify_account_key(new_key)
        verify_account
        remove_verify_account_key
        if verify_account_autologin?
          autologin_session("verify_account")
        end
        remove_session_value(verify_account_session_key)
        set_notice_flash verify_account_notice_flash
        redirect verify_account_redirect
      end
    end

    # ==> Redirects
    # Redirect to login page after logout.
    logout_redirect "/login"

    # Redirect to "/home" after login
    login_redirect "/home"

    # Redirect to the app from login and registration pages if already logged in.
    already_logged_in { redirect login_redirect }

    # Redirect to login page after creating account
    # create_account_redirect { login_path }

    # Redirect to wherever login redirects to after account verification.
    verify_account_redirect { login_redirect }

    # Redirect to login page after password reset.
    reset_password_redirect { login_path }

    # Ensure requiring login follows login route changes.
    require_login_redirect { login_path }

    # ==> Deadlines
    # Change default deadlines for some actions.
    verify_account_grace_period 1
    reset_password_deadline_interval Hash[hours: 2]
    # verify_login_change_deadline_interval Hash[days: 2]
    # remember_deadline_interval Hash[days: 30]

    # Customize
    login_label { "Email" }
    login_button { "Sign in" }
    login_page_title { "Sign in to your account" }
    login_error_flash { "Incorrect Email or Password" }
    logout_button { "Sign out" }
    remember_remember_label { "Remember me" }
    reset_password_request_link_text { "Forgot your password?" }
    reset_password_request_page_title { "Reset your password" }
    reset_password_request_button { "Reset your password" }
    reset_password_explanatory_text { "Enter your email and we'll send you a link to reset your password." }
    reset_password_page_title { "Create new password" }
    reset_password_button { "Reset password" }
    resend_verify_account_page_title { "Didn't receive verification email?" }
    verify_account_resend_button { "Resend verification" }
    verify_account_resend_link_text { "Verify now" }
    verify_account_resend_explanatory_text { "No worries. We'll gladly send you a new one" }
  end
end
