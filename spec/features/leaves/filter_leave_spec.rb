# frozen_string_literal: true

require "rails_helper"

describe "Filter leave requests" do
  let(:lt_annual_leave) { create(:leave_type, name: "Annual Leave") }
  let(:lt_sick_leave) { create(:leave_type, name: "Sick Leave") }
  let(:employee) { create(:employee) }
  let(:leave1) { create(:leave, leave_type: lt_sick_leave, manager: employee.manager, employee:) }
  let(:leave2) do
    create(:leave, :half_day, :approved, leave_type: lt_annual_leave, manager: employee.manager, employee:)
  end

  around do |example|
    travel_to(Time.zone.local(2023, 2)) { example.run }
  end

  before do
    lt_annual_leave
    lt_sick_leave
    leave1
    leave2
    login(employee.account)
  end

  it "total filters" do
    visit leaves_path
    expect(page).to(have_content("My Leaves"))
    expect(page).to(have_current_path(leaves_path))
    expect(find(
      :xpath,
      ".//form[@id='leave_search']/div",
    )).to(have_selector("div[data-controller='dropdown']", count: 3))
  end

  it "filter by status" do
    visit leaves_path

    within :xpath, ".//form[@id='leave_search']/div/div[@data-controller='dropdown'][1]" do
      click_button("Status", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      check("query_approval_status_in_0")
      check("query_approval_status_in_1")
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Status: Pending, Approved"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    expect(params["query"]["approval_status_in"]).to(contain_exactly("0", "1"))
    expect(find("turbo-frame#leaves-list")).to(have_selector("table tbody tr", count: 2))
  end

  it "filter by leave type" do
    visit leaves_path

    within :xpath, ".//form[@id='leave_search']/div/div[@data-controller='dropdown'][2]" do
      click_button("Leave type", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select lt_annual_leave.name, from: "query[leave_type_id_eq]"
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Leave type: #{lt_annual_leave.name}"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    expect(params["query"]["leave_type_id_eq"]).to(eq(lt_annual_leave.id.to_s))
    expect(find("turbo-frame#leaves-list")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by total days - equals" do
    visit leaves_path

    within :xpath, ".//form[@id='leave_search']/div/div[@data-controller='dropdown'][3]" do
      click_button("Total days", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select("equals", from: "query_c_p")
      fill_in("query_v", with: "2")
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Total days: Equals 2"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    number_of_days_query = params["query"]["c"].find { |x| x["a"].include?("number_of_days") }
    expect(number_of_days_query["p"]).to(eq("eq"))
    expect(number_of_days_query["v"]).to(contain_exactly("2"))
    expect(find("turbo-frame#leaves-list")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by total days - less than" do
    visit leaves_path

    within :xpath, ".//form[@id='leave_search']/div/div[@data-controller='dropdown'][3]" do
      click_button("Total days", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select("less than", from: "query_c_p")
      fill_in("query_v", with: "2")
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Total days: Less than 2"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    number_of_days_query = params["query"]["c"].find { |x| x["a"].include?("number_of_days") }
    expect(number_of_days_query["p"]).to(eq("lt"))
    expect(number_of_days_query["v"]).to(contain_exactly("2"))
    expect(find("turbo-frame#leaves-list")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by total days - greater than" do
    visit leaves_path

    within :xpath, ".//form[@id='leave_search']/div/div[@data-controller='dropdown'][3]" do
      click_button("Total days", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select("greater than", from: "query_c_p")
      fill_in("query_v", with: "1")
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Total days: Greater than 1"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    number_of_days_query = params["query"]["c"].find { |x| x["a"].include?("number_of_days") }
    expect(number_of_days_query["p"]).to(eq("gt"))
    expect(number_of_days_query["v"]).to(contain_exactly("1"))
    expect(find("turbo-frame#leaves-list")).to(have_selector("table tbody tr", count: 1))
  end

  it "clear filters" do
    visit leaves_path

    within :xpath, ".//form[@id='leave_search']/div/div[@data-controller='dropdown'][2]" do
      click_button("Leave type", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select lt_annual_leave.name, from: "query[leave_type_id_eq]"
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Leave type: #{lt_annual_leave.name}"))
    end
    expect(find("turbo-frame#leaves-list")).to(have_selector("table tbody tr", count: 1))

    within :xpath, ".//turbo-frame[@id='leaves-list']/div/div/form" do
      expect(page).to(have_button("Clear Filters"))
      click_button("Clear Filters")
      expect(page).not_to(have_button("Clear Filters"))
    end
  end
end
