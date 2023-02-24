# frozen_string_literal: true

require "rails_helper"

describe "Reset password" do
  let(:password) { Faker::Internet.password(min_length: 8, max_length: 10) }
  let(:account) { create(:account, password:) }
  let(:employee) { create(:employee, account:) }
  let(:rodauth_app) do
    ->(account) do
      app = RodauthApp.rodauth.allocate
      app.instance_variable_set(:@account, { id: account.id })
      app
    end
  end
  let(:email_token) do
    ->(rodauth, account_id, key) do
      "#{account_id}_#{rodauth.compute_hmac(key)}"
    end
  end

  before do
    employee
  end

  it "valid link", sidekiq: :inline do
    account = employee.account
    expect(account.password_reset_key).to(be_blank)
    RodauthApp.rodauth.reset_password_request(login: account.email)
    reset_password_key = account.reload.password_reset_key.key
    expect(reset_password_key).to(be_present)
    rodauth = rodauth_app.call(account)
    rodauth.instance_variable_set(:"@reset_password_key_value", reset_password_key)
    email_link = rodauth.reset_password_path(key: email_token.call(rodauth, account.id, reset_password_key))
    visit email_link
    expect(page).to(have_selector("h1", text: "Create new password"))
    within("form") do
      expect(page).to(have_field("password", type: "password"))
      expect(page).to(have_field("password-confirm", type: "password"))
      expect(page).to(have_button("Reset password"))
    end
  end

  it "invalid link - key is invalid" do
    visit RodauthApp.rodauth.reset_password_path(key: "invalid-link")
    expect(page).to(have_current_path(RodauthApp.rodauth.login_path))
    expect(page).to(have_selector(
      "div.alert",
      text: "There was an error resetting your password: invalid or expired password reset key",
    ))
  end

  # FIXME: access the expired link still possible in the test
  it "valid link - key has expired" do
  end

  it "valid password", sidekiq: :inline do
    account = employee.account
    expect(account.password_reset_key).to(be_blank)
    RodauthApp.rodauth.reset_password_request(login: account.email)
    reset_password_key = account.reload.password_reset_key.key
    expect(reset_password_key).to(be_present)
    rodauth = rodauth_app.call(account)
    rodauth.instance_variable_set(:"@reset_password_key_value", reset_password_key)
    email_link = rodauth.reset_password_path(key: email_token.call(rodauth, account.id, reset_password_key))
    visit email_link
    expect(page).to(have_selector("h1", text: "Create new password"))
    within("form") do
      new_password = Faker::Internet.password(min_length: 8)
      fill_in("password", with: new_password)
      fill_in("password-confirm", with: new_password)
      click_button("Reset password")
    end
    expect(account.reload.password_reset_key).to(be_blank)
  end

  it "invalid password - too short", sidekiq: :inline do
    account = employee.account
    expect(account.password_reset_key).to(be_blank)
    RodauthApp.rodauth.reset_password_request(login: account.email)
    reset_password_key = account.reload.password_reset_key.key
    expect(reset_password_key).to(be_present)
    rodauth = rodauth_app.call(account)
    rodauth.instance_variable_set(:"@reset_password_key_value", reset_password_key)
    email_link = rodauth.reset_password_path(key: email_token.call(rodauth, account.id, reset_password_key))
    visit email_link
    expect(page).to(have_selector("h1", text: "Create new password"))
    within("form") do
      new_password = Faker::Internet.password(min_length: 2, max_length: 4)
      fill_in("password", with: new_password)
      fill_in("password-confirm", with: new_password)
      click_button("Reset password")
      expect(page).to(have_selector(
        "span.form__error",
        text: "invalid password, does not meet requirements (minimum 8 characters)",
      ))
    end
  end

  it "invalid password - can't use the current password", sidekiq: :inline do
    account = employee.account
    expect(account.password_reset_key).to(be_blank)
    RodauthApp.rodauth.reset_password_request(login: account.email)
    reset_password_key = account.reload.password_reset_key.key
    expect(reset_password_key).to(be_present)
    rodauth = rodauth_app.call(account)
    rodauth.instance_variable_set(:"@reset_password_key_value", reset_password_key)
    email_link = rodauth.reset_password_path(key: email_token.call(rodauth, account.id, reset_password_key))
    visit email_link
    expect(page).to(have_selector("h1", text: "Create new password"))
    within("form") do
      fill_in("password", with: password)
      fill_in("password-confirm", with: Faker::Internet.password(min_length: 2, max_length: 4))
      click_button("Reset password")
      expect(page).to(have_selector("span.form__error", text: "invalid password, same as current password"))
    end
  end

  it "invalid password - password do not match", sidekiq: :inline do
    account = employee.account
    expect(account.password_reset_key).to(be_blank)
    RodauthApp.rodauth.reset_password_request(login: account.email)
    reset_password_key = account.reload.password_reset_key.key
    expect(reset_password_key).to(be_present)
    rodauth = rodauth_app.call(account)
    rodauth.instance_variable_set(:"@reset_password_key_value", reset_password_key)
    email_link = rodauth.reset_password_path(key: email_token.call(rodauth, account.id, reset_password_key))
    visit email_link
    expect(page).to(have_selector("h1", text: "Create new password"))
    within("form") do
      fill_in("password", with: "12345678")
      fill_in("password-confirm", with: Faker::Internet.password(min_length: 2, max_length: 4))
      click_button("Reset password")
      expect(page).to(have_selector("span.form__error", text: "passwords do not match"))
    end
  end
end
