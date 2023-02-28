# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExampleLength
RSpec.describe(Installation::StepperComponent, type: :component) do
  it "renders default" do
    render_inline(described_class.new)
    total = Installation::StepperComponent::STEPS.length
    expect(page).to(have_selector("div.stepper div.stepper__item", count: total))
  end

  it "renders step 1" do
    render_inline(described_class.new(current_step: 1))
    expect(page).to(have_selector("div.stepper > div:nth-child(1).stepper__item--current"))
    expect(page).to(have_selector("div.stepper > div:nth-child(2).stepper__item"))
    expect(page).to(have_selector("div.stepper > div:nth-child(3).stepper__item"))
    expect(page).to(have_selector("div.stepper > div:nth-child(4).stepper__item"))
    expect(page).to(have_selector("div.stepper > div:nth-child(5).stepper__item"))
  end

  it "renders step 2" do
    render_inline(described_class.new(current_step: 2))
    expect(page).to(have_selector("div.stepper > div:nth-child(1).stepper__item--complete"))
    expect(page).to(have_selector("div.stepper > div:nth-child(2).stepper__item--current"))
    expect(page).to(have_selector("div.stepper > div:nth-child(3).stepper__item"))
    expect(page).to(have_selector("div.stepper > div:nth-child(4).stepper__item"))
    expect(page).to(have_selector("div.stepper > div:nth-child(5).stepper__item"))
  end

  it "renders step 3" do
    render_inline(described_class.new(current_step: 3))
    expect(page).to(have_selector("div.stepper > div:nth-child(1).stepper__item--complete"))
    expect(page).to(have_selector("div.stepper > div:nth-child(2).stepper__item--complete"))
    expect(page).to(have_selector("div.stepper > div:nth-child(3).stepper__item--current"))
    expect(page).to(have_selector("div.stepper > div:nth-child(4).stepper__item"))
    expect(page).to(have_selector("div.stepper > div:nth-child(5).stepper__item"))
  end

  it "renders step 4" do
    render_inline(described_class.new(current_step: 4))
    expect(page).to(have_selector("div.stepper > div:nth-child(1).stepper__item--complete"))
    expect(page).to(have_selector("div.stepper > div:nth-child(2).stepper__item--complete"))
    expect(page).to(have_selector("div.stepper > div:nth-child(3).stepper__item--complete"))
    expect(page).to(have_selector("div.stepper > div:nth-child(4).stepper__item--current"))
    expect(page).to(have_selector("div.stepper > div:nth-child(5).stepper__item"))
  end

  it "renders step 5" do
    render_inline(described_class.new(current_step: 5))
    expect(page).to(have_selector("div.stepper > div:nth-child(1).stepper__item--complete"))
    expect(page).to(have_selector("div.stepper > div:nth-child(2).stepper__item--complete"))
    expect(page).to(have_selector("div.stepper > div:nth-child(3).stepper__item--complete"))
    expect(page).to(have_selector("div.stepper > div:nth-child(4).stepper__item--complete"))
    expect(page).to(have_selector("div.stepper > div:nth-child(5).stepper__item--current"))
  end
end
# rubocop:enable RSpec/ExampleLength
