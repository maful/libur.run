# frozen_string_literal: true

require "rails_helper"

describe "Filter user" do
  let!(:company) { create(:company) }
  let(:account) { create(:account, :verified) }
  let!(:admin) { create(:employee, position: "CEO", with_admin_role: true, with_manager_assigned: false, account:) }
  let!(:manager) do
    create(:employee, position: "Engineering Manager", with_manager_role: true, with_manager_assigned: false)
  end
  let!(:employee) { create(:employee, position: "Senior Software Engineer", with_manager_assigned: false) }
  let!(:employee_archived) do
    create(:employee, :archived, position: "Junior Software Engineer", with_manager_assigned: false)
  end

  before do
    login(account)
  end

  it "filter by email" do
    visit users_path
    expect(page).to(have_content("Users"))
    expect(page).to(have_current_path(users_path))

    email = employee.account.email
    within :xpath, ".//form[@id='employee_search']/div/div[@data-controller='dropdown'][1]" do
      click_button("Email", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      fill_in "query[account_email_eq]", with: email
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Email: #{email}"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    expect(params["query"]["account_email_eq"]).to(eq(email))
    expect(find("turbo-frame#users-table")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by status" do
    visit users_path
    expect(page).to(have_content("Users"))
    expect(page).to(have_current_path(users_path))

    within :xpath, ".//form[@id='employee_search']/div/div[@data-controller='dropdown'][2]" do
      click_button("Status", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      check("query_by_status_archived")
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Status: Archived"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    expect(params["query"]["by_status"]).to(contain_exactly("archived"))
    expect(find("turbo-frame#users-table")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by roles" do
    visit users_path
    expect(page).to(have_content("Users"))
    expect(page).to(have_current_path(users_path))

    within :xpath, ".//form[@id='employee_search']/div/div[@data-controller='dropdown'][3]" do
      click_button("Roles", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      check("query_by_roles_1") # admin
      check("query_by_roles_4") # manager
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Roles: Manager, Admin"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    expect(params["query"]["by_roles"]).to(contain_exactly("1", "4"))
    expect(find("turbo-frame#users-table")).to(have_selector("table tbody tr", count: 2))
  end

  it "filter by position - equals" do
    visit users_path
    expect(page).to(have_content("Users"))
    expect(page).to(have_current_path(users_path))

    within :xpath, ".//form[@id='employee_search']/div/div[@data-controller='dropdown'][4]" do
      click_button("Position", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select "equals", from: "query[c][][p]"
      fill_in "query[c][][v][]", with: "Senior Software Engineer"
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Position: Equals Senior Software Engineer"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    position_query = params["query"]["c"].find { |x| x["a"].include?("position") }
    expect(position_query["p"]).to(eq("eq"))
    expect(position_query["v"]).to(contain_exactly("Senior Software Engineer"))
    expect(find("turbo-frame#users-table")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by position - starts with" do
    visit users_path
    expect(page).to(have_content("Users"))
    expect(page).to(have_current_path(users_path))

    within :xpath, ".//form[@id='employee_search']/div/div[@data-controller='dropdown'][4]" do
      click_button("Position", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select "starts with", from: "query[c][][p]"
      fill_in "query[c][][v][]", with: "Engineering"
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Position: Starts with Engineering"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    position_query = params["query"]["c"].find { |x| x["a"].include?("position") }
    expect(position_query["p"]).to(eq("start"))
    expect(position_query["v"]).to(contain_exactly("Engineering"))
    expect(find("turbo-frame#users-table")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by position - ends with" do
    visit users_path
    expect(page).to(have_content("Users"))
    expect(page).to(have_current_path(users_path))

    within :xpath, ".//form[@id='employee_search']/div/div[@data-controller='dropdown'][4]" do
      click_button("Position", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select "ends with", from: "query[c][][p]"
      fill_in "query[c][][v][]", with: "Engineer"
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Position: Ends with Engineer"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    position_query = params["query"]["c"].find { |x| x["a"].include?("position") }
    expect(position_query["p"]).to(eq("end"))
    expect(position_query["v"]).to(contain_exactly("Engineer"))
    expect(find("turbo-frame#users-table")).to(have_selector("table tbody tr", count: 2))
  end

  it "clear filters" do
    visit users_path
    expect(page).to(have_content("Users"))
    expect(page).to(have_current_path(users_path))

    email = employee.account.email
    within :xpath, ".//form[@id='employee_search']/div/div[@data-controller='dropdown'][1]" do
      click_button("Email", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      fill_in "query[account_email_eq]", with: email
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Email: #{email}"))
    end

    expect(find("turbo-frame#users-table")).to(have_selector("table tbody tr", count: 1))

    within :xpath, ".//turbo-frame[@id='users-table']/div/div/form" do
      expect(page).to(have_button("Clear Filters"))
      click_button("Clear Filters")
      expect(page).not_to(have_button("Clear Filters"))
    end

    expect(find("turbo-frame#users-table")).to(have_selector("table tbody tr", count: 4))
  end
end
