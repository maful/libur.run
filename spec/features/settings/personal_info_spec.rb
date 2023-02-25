# frozen_string_literal: true

require "rails_helper"

describe "Update personal info" do
  let(:employee) { create(:employee, with_manager_assigned: true) }

  before do
    login(employee.account)
  end

  it "navigation" do
    visit home_path

    # click the dropdown menu
    user_menu = find("nav[aria-label='Main'] button#user-menu-button")
    user_menu.click

    # verify the dropdown menu
    dropdown_menu = user_menu.sibling("div:not(.hidden)")
    expect(dropdown_menu).to(be_visible)
    expect(dropdown_menu).to(have_content("Settings"))
    expect(dropdown_menu).to(have_content("Sign out"))

    # click the Settings link
    click_link("Settings", href: settings_root_path)
    expect(page).to(have_current_path(settings_my_profile_path))
    expect(page).to(have_selector("div.tabs > div[role='tablist'] > div[role='presentation']", count: 4))
    click_link("Personal", href: settings_me_path)
    expect(page).to(have_selector("h3", text: "Personal Info"))
  end

  it "valid inputs", sidekiq: :inline do
    visit settings_me_path

    new_name = Faker::Name.name
    new_email = Faker::Internet.unique.email(domain: "example")
    new_bio = Faker::Lorem.sentence(word_count: 6)
    expect(employee.avatar).not_to(be_attached)
    within("form.simple_form") do
      fill_in("user[name]", with: new_name)
      fill_in("user[account_attributes][email]", with: new_email)
      attach_file("user[avatar]", file_fixture("avatar.png").to_s)
      fill_in("user[about]", with: new_bio)
      click_button("Save")
    end
    expect(page).to(have_content("Personal Info was successfully updated."))
    expect(employee.reload.avatar).to(be_attached)
    within("form.simple_form") do
      expect(find("input[name='user[name]']").value).to(eq(new_name))
      expect(find("input[name='user[account_attributes][email]']").value).to(eq(new_email))
      expect(find("textarea[name='user[about]']").value).to(eq(new_bio))
      expect(page).to(have_selector("img[alt='preview image']", count: 1))
    end
  end

  it "invalid inputs" do
    visit settings_me_path

    within("form.simple_form") do
      fill_in("user[name]", with: "")
      fill_in("user[account_attributes][email]", with: "")
      click_button("Save")
      expect(page).to(have_selector("p.input-group__error-message", text: "Name can't be blank"))
      expect(page).to(have_selector("p.input-group__error-message", text: "Email can't be blank"))
    end
  end

  it "invalid avatar - content type" do
    visit settings_me_path

    within("form.simple_form") do
      attach_file("user[avatar]", file_fixture("logo-dark.svg").to_s)
      click_button("Save")
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: I18n.t("activerecord.errors.messages.content_type"),
      ))
    end
  end

  it "invalid avatar - file size" do
    visit settings_me_path

    within("form.simple_form") do
      attach_file("user[avatar]", file_fixture("big-image.jpg"))
      click_button("Save")
      max_size = ActiveSupport::NumberHelper.number_to_human_size(Employee::MAX_AVATAR_SIZE)
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: I18n.t("activerecord.errors.messages.max_size_error", max_size:),
      ))
    end
  end
end
