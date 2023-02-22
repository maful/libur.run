# frozen_string_literal: true

module DataVariables
  mattr_accessor :company, :admin

  class << self
    def reset
      self.company = nil
      self.admin = nil
    end
  end
end

RSpec.configure do |config|
  config.include(DataVariables)
end
