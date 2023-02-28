# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PageHeaderComponent, type: :component) do
  let(:title) { "Page Header" }

  # TODO: Test the breadcrumb as it's not generated in this spec
  it "renders default" do
    render_inline(described_class.new(title:))
    expect(page).to(have_selector("h1", text: title))
    expect(page).to(have_selector("nav.breadcrumb[aria-label='Breadcrumb']"))
  end

  it "renders without breadcrumb" do
    render_inline(described_class.new(title:, show_breadcrumb: false))
    expect(page).to(have_selector("h1", text: title))
    expect(page).not_to(have_selector("nav.breadcrumb[aria-label='Breadcrumb']"))
  end

  # rubocop:disable RSpec/ExampleLength
  it "renders with supporting text" do
    supporting_text = "Supporting Text"
    render_inline(described_class.new(title:)) do |c|
      c.with_supporting_text { supporting_text }
    end
    expect(page).to(have_selector("h1", text: title))
    expect(page).to(have_selector("p", text: supporting_text))
    expect(page).to(have_selector("nav.breadcrumb[aria-label='Breadcrumb']"))
  end
  # rubocop:enable RSpec/ExampleLength

  # rubocop:disable RSpec/ExampleLength, RSpec/DescribedClass
  it "renders with actions" do
    render_in_view_context do
      render(PageHeaderComponent.new(title: "Page Header")) do |c|
        c.with_actions { tag.button("Actions", "test-id": "random") }
      end
    end
    expect(page).to(have_selector("h1", text: title))
    expect(page).to(have_button("Actions"))
    expect(page).to(have_selector("nav.breadcrumb[aria-label='Breadcrumb']"))
  end
  # rubocop:enable RSpec/ExampleLength, RSpec/DescribedClass
end
