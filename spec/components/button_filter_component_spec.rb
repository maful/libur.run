# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExampleLength, RSpec/DescribedClass
RSpec.describe(ButtonFilterComponent, type: :component) do
  it "renders default" do
    render_in_view_context do
      render(ButtonFilterComponent.new(label: "ID")) { tag.h1("Content") }
    end
    btn_class = ButtonDropdownComponent::BUTTON_TYPES[:filter].gsub(" ", ".")
    expect(page).to(have_selector("button.#{btn_class}", text: "ID"))
  end

  it "renders with string value" do
    render_in_view_context do
      render(ButtonFilterComponent.new(label: "ID", value: "This is ID")) { tag.h1("Content") }
    end
    btn_class = ButtonDropdownComponent::BUTTON_TYPES[:filter_active].gsub(" ", ".")
    expect(page).to(have_selector("button.#{btn_class}", text: "ID: This is ID"))
  end

  it "renders with array value" do
    render_in_view_context do
      render(ButtonFilterComponent.new(label: "Status", value: ["Pending", "In Progress"])) { tag.h1("Content") }
    end
    btn_class = ButtonDropdownComponent::BUTTON_TYPES[:filter_active].gsub(" ", ".")
    expect(page).to(have_selector("button.#{btn_class}", text: "Status: Pending, In Progress"))
  end

  it "renders with medium size" do
    render_in_view_context do
      render(ButtonFilterComponent.new(label: "ID")) { tag.h1("Content") }
    end
    btn_class = ButtonDropdownComponent::BUTTON_TYPES[:filter].gsub(" ", ".")
    expect(page).to(have_selector("button.#{btn_class}", text: "ID"))
    expect(page).to(have_selector("div.button-dropdown__menu"))
  end

  it "renders with large size" do
    render_in_view_context do
      render(ButtonFilterComponent.new(label: "ID", size: :large)) { tag.h1("Content") }
    end
    btn_class = ButtonDropdownComponent::BUTTON_TYPES[:filter].gsub(" ", ".")
    expect(page).to(have_selector("button.#{btn_class}", text: "ID"))
    size_class = ButtonDropdownComponent::MENU_SIZE_CLASSES[:large].gsub(" ", ".")
    expect(page).to(have_selector("div.button-dropdown__menu.#{size_class}"))
  end
end
# rubocop:enable RSpec/ExampleLength, RSpec/DescribedClass
