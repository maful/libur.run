# frozen_string_literal: true

require "rails_helper"

describe "Company profile" do
  let(:company) { DataVariables.company }
  let(:employee) { create(:employee) }

  before do
    login(DataVariables.admin.account)
    employee
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
    expect(page).to(have_selector("div.tabs > div[role='tablist'] > div[role='presentation']", count: 5))
    click_link("Company", href: settings_company_path)
    expect(page).to(have_selector("h3", text: "Company Profile"))
  end

  it "valid inputs", sidekiq: :inline do
    visit settings_company_path

    new_name = Faker::Company.name
    new_phone = Faker::PhoneNumber.cell_phone_in_e164
    new_email = Faker::Internet.unique.email(domain: "example")
    employee_decorator = EmployeeDecorator.new(employee)
    expect(company.logo).not_to(be_attached)
    within("form.simple_form#form_company_#{company.id}") do
      fill_in("company[name]", with: new_name)
      attach_file("company[logo]", file_fixture("avatar.png").to_s)
      fill_in("company[phone]", with: new_phone)
      fill_in("company[email]", with: new_email)
      find("select#company_finance_approver_id option", text: employee_decorator.name_with_email).select_option
      click_button("Update Company Profile")
    end
    expect(page).to(have_content("Company Profile was successfully updated."))
    expect(company.reload.logo).to(be_attached)
    within("form.simple_form#form_company_#{company.id}") do
      expect(find("input[name='company[name]']").value).to(eq(new_name))
      expect(find("input[name='company[phone]']").value).to(eq(new_phone))
      expect(find("input[name='company[email]']").value).to(eq(new_email))
      expect(page).to(have_select("company[finance_approver_id]", selected: employee_decorator.name_with_email))
      expect(page).to(have_selector("img[alt='preview image']", count: 1))
    end
  end

  it "invalid inputs" do
    visit settings_company_path

    within("form.simple_form#form_company_#{company.id}") do
      fill_in("company[name]", with: "")
      fill_in("company[email]", with: "")
      click_button("Update Company Profile")
      expect(page).to(have_selector("p.input-group__error-message", text: "Name can't be blank"))
      expect(page).to(have_selector("p.input-group__error-message", text: "Email can't be blank"))
    end
  end

  it "invalid logo - content type" do
    visit settings_company_path

    within("form.simple_form#form_company_#{company.id}") do
      attach_file("company[logo]", file_fixture("logo-dark.svg").to_s)
      click_button("Update Company Profile")
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: I18n.t("errors.messages.content_type_invalid"),
      ))
    end
  end

  it "invalid logo - file size" do
    visit settings_company_path

    within("form.simple_form#form_company_#{company.id}") do
      avatar_file = file_fixture("big-image.jpg")
      attach_file("company[logo]", avatar_file.to_s)
      click_button("Update Company Profile")
      file_size = ActiveSupport::NumberHelper.number_to_human_size(avatar_file.size)
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: I18n.t("errors.messages.file_size_out_of_range", file_size:),
      ))
    end
  end
end
