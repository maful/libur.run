# frozen_string_literal: true

class Installation::StepperComponent < ViewComponent::Base
  attr_reader :current_step

  STEPS = [
    { title: "Introduction", subtitle: "Welcome to Libur.run" },
    { title: "License", subtitle: "Understanding License and Terms of Use" },
    { title: "Personal information", subtitle: "Please provide your name and email" },
    { title: "Company details", subtitle: "Enter your business details" },
    { title: "Complete", subtitle: "Thank you for choosing Libur.run" },
  ]

  def initialize(current_step: 1)
    @current_step = current_step - 1
  end
end
