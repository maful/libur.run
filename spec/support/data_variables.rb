# frozen_string_literal: true

module DataVariables
  mattr_accessor :company, :admin

  def self.reset
    self.company = nil
    self.admin = nil
  end
end

RSpec.configure do |config|
  config.include(DataVariables)
end
