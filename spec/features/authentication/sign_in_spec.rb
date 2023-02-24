# frozen_string_literal: true

require "rails_helper"

describe "Sign in" do
  let(:password) { Faker::Internet.password(min_length: 8) }
  let(:account) { create(:account, password:) }
  let(:employee) { create(:employee, account:) }

  before do
    employee
  end

  it "navigation", :selenium_chrome do
    visit RodauthApp.rodauth.login_path
    expect(page).to(have_selector("h1", text: "Sign in to your account"))
    expect(page).to(have_current_path(RodauthApp.rodauth.login_path))
  end

  it "valid credentials", :selenium_chrome do
    visit RodauthApp.rodauth.login_path
    within("form") do
      fill_in("login", with: account.email)
      fill_in("password", with: password)
      click_button("Sign in")
    end

    visit home_path
    expect(page).to(have_current_path(home_path))
  end

  it "invalid email", :selenium_chrome do
    visit RodauthApp.rodauth.login_path
    within("form") do
      fill_in("login", with: Faker::Internet.unique.email(domain: "examplecom"))
      fill_in("password", with: password)
      click_button("Sign in")
      expect(page).to(have_selector("div.alert.alert--error", text: "Incorrect Email or Password"))
    end
  end

  it "invalid password", :selenium_chrome do
    visit RodauthApp.rodauth.login_path
    within("form") do
      fill_in("login", with: account.email)
      fill_in("password", with: "#{password}123")
      click_button("Sign in")
      expect(page).to(have_selector("div.alert.alert--error", text: "Incorrect Email or Password"))
    end
  end

  it "have not setup the app", :selenium_chrome do
    DataVariables.company.destroy
    visit RodauthApp.rodauth.login_path
    # redirected to installation page
    expect(page).to(have_current_path(installation_index_path))
  end
end
