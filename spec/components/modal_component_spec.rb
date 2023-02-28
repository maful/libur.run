# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExampleLength, RSpec/DescribedClass
RSpec.describe(ModalComponent, type: :component) do
  it "renders default" do
    render_in_view_context do
      render(ModalComponent.new) do |c|
        c.with_header(title: "Modal Header", icon: "bolt")
        c.with_body { tag.div("Modal Body") }
        c.with_footer { tag.div("Modal Footer") }
      end
    end
    expect(page).to(have_selector("div.modal[data-controller='modal']"))
    expect(page).to(have_selector("h1.modal__title", text: "Modal Header"))
    expect(page).to(have_selector("div.modal__body", text: "Modal Body"))
    expect(page).to(have_selector("div.modal__footer", text: "Modal Footer"))
  end

  it "renders with description text" do
    render_in_view_context do
      render(ModalComponent.new) do |c|
        c.with_header(title: "Modal Header", icon: "bolt") do |ch|
          ch.with_supporting_text { "Supporting Text" }
        end
        c.with_body { tag.div("Modal Body") }
        c.with_footer { tag.div("Modal Footer") }
      end
    end
    expect(page).to(have_selector("h1.modal__title", text: "Modal Header"))
    expect(page).to(have_selector("p.modal__help", text: "Supporting Text"))
  end

  it "renders medium size" do
    render_in_view_context do
      render(ModalComponent.new) do |c|
        c.with_header(title: "Modal Header", icon: "bolt")
        c.with_body { tag.div("Modal Body") }
        c.with_footer { tag.div("Modal Footer") }
      end
    end
    expect(page).to(have_selector("div.modal[data-controller='modal']"))
    expect(page).to(have_selector("div.modal__container"))
  end

  it "renders large size" do
    render_in_view_context do
      render(ModalComponent.new(size: :large)) do |c|
        c.with_header(title: "Modal Header", icon: "bolt")
        c.with_body { tag.div("Modal Body") }
        c.with_footer { tag.div("Modal Footer") }
      end
    end
    expect(page).to(have_selector("div.modal[data-controller='modal']"))
    size_class = ModalComponent::SIZE_CLASSES[:large]
    expect(page).to(have_selector("div.modal__container.#{size_class}"))
  end
end
# rubocop:enable RSpec/ExampleLength, RSpec/DescribedClass
