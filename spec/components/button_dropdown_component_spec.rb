# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExampleLength, RSpec/DescribedClass
RSpec.describe(ButtonDropdownComponent, type: :component) do
  it "renders default" do
    render_in_view_context do
      render(ButtonDropdownComponent.new) { tag.h1("Content") }
    end
    expect(page).to(have_button("Actions"))
    expect(page.find("div.button-dropdown__links")).to(have_selector("h1", text: "Content"))
  end

  it "renders custom title" do
    render_in_view_context do
      render(ButtonDropdownComponent.new(text: "Dropdown")) { tag.h1("Content") }
    end
    expect(page).to(have_button("Dropdown"))
    expect(page.find("div.button-dropdown__links")).to(have_selector("h1", text: "Content"))
  end

  it "renders navbar type" do
    render_in_view_context do
      render(ButtonDropdownComponent.new(type: :navbar)) { tag.h1("Content") }
    end
    btn_class = ButtonDropdownComponent::BUTTON_TYPES[:navbar].gsub(" ", ".")
    expect(page).to(have_selector("button.#{btn_class}", text: "Actions"))
  end

  it "renders filter type" do
    render_in_view_context do
      render(ButtonDropdownComponent.new(type: :filter)) { tag.h1("Content") }
    end
    btn_class = ButtonDropdownComponent::BUTTON_TYPES[:filter].gsub(" ", ".")
    expect(page).to(have_selector("button.#{btn_class}", text: "Actions"))
  end

  it "renders filter active type" do
    render_in_view_context do
      render(ButtonDropdownComponent.new(type: :filter_active)) { tag.h1("Content") }
    end
    btn_class = ButtonDropdownComponent::BUTTON_TYPES[:filter_active].gsub(" ", ".")
    expect(page).to(have_selector("button.#{btn_class}", text: "Actions"))
  end

  it "renders right direction" do
    render_in_view_context do
      render(ButtonDropdownComponent.new(direction: :right)) { tag.h1("Content") }
    end
    expect(page).to(have_button("Actions"))
    direction_class = ButtonDropdownComponent::MENU_DIRECTIONS[:right].gsub(" ", ".")
    expect(page).to(have_selector("div.button-dropdown__menu.#{direction_class}"))
  end

  it "renders left direction" do
    render_in_view_context do
      render(ButtonDropdownComponent.new(direction: :left)) { tag.h1("Content") }
    end
    expect(page).to(have_button("Actions"))
    direction_class = ButtonDropdownComponent::MENU_DIRECTIONS[:left].gsub(" ", ".")
    expect(page).to(have_selector("div.button-dropdown__menu.#{direction_class}"))
  end

  it "renders medium size" do
    render_in_view_context do
      render(ButtonDropdownComponent.new) { tag.h1("Content") }
    end
    expect(page).to(have_button("Actions"))
    expect(page).to(have_selector("div.button-dropdown__menu"))
  end

  it "renders large size" do
    render_in_view_context do
      render(ButtonDropdownComponent.new(size: :large)) { tag.h1("Content") }
    end
    expect(page).to(have_button("Actions"))
    size_class = ButtonDropdownComponent::MENU_SIZE_CLASSES[:large].gsub(" ", ".")
    expect(page).to(have_selector("div.button-dropdown__menu.#{size_class}"))
  end

  it "renders right icon position" do
    render_in_view_context do
      render(ButtonDropdownComponent.new(icon_position: :right)) { tag.h1("Content") }
    end
    expect(page).to(have_button("Actions"))
    icon_position_class = ButtonDropdownComponent::ICON_POSITION_CLASSES[:right].gsub(" ", ".")
    expect(page).to(have_selector("div.button-dropdown__icon.#{icon_position_class}"))
  end

  it "renders left icon position" do
    render_in_view_context do
      render(ButtonDropdownComponent.new(icon_position: :left)) { tag.h1("Content") }
    end
    expect(page).to(have_button("Actions"))
    icon_position_class = ButtonDropdownComponent::ICON_POSITION_CLASSES[:left].gsub(" ", ".")
    expect(page).to(have_selector("div.button-dropdown__icon.#{icon_position_class}"))
  end

  it "renders links" do
    render_in_view_context do
      render(ButtonDropdownComponent.new) do |c|
        c.with_links([
          { name: "Login", href: "/login" },
          { name: "Register", href: "/register" },
        ])
      end
    end
    expect(page).to(have_button("Actions"))
    expect(page.find("div.button-dropdown__links")).to(have_selector("a.button-dropdown__link", count: 2))
  end

  it "renders with hide link" do
    render_in_view_context do
      render(ButtonDropdownComponent.new) do |c|
        c.with_links([
          { name: "Login", href: "/login", hide: true },
          { name: "Register", href: "/register" },
        ])
      end
    end
    expect(page).to(have_button("Actions"))
    expect(page.find("div.button-dropdown__links")).to(have_selector("a.button-dropdown__link", count: 1))
  end

  it "renders with custom attribute link" do
    render_in_view_context do
      render(ButtonDropdownComponent.new) do |c|
        c.with_links([
          { name: "Register", href: "/register", data: { turbo_method: :patch } },
        ])
      end
    end
    expect(page).to(have_button("Actions"))
    expect(page.find("div.button-dropdown__links")).to(have_selector("a[data-turbo-method='patch']", count: 1))
  end
end
# rubocop:enable RSpec/ExampleLength, RSpec/DescribedClass
