# frozen_string_literal: true

require "sidekiq/testing"

RSpec.configure do |config|
  config.before do |example|
    Sidekiq::Worker.clear_all

    if example.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!
    else
      Sidekiq::Testing.fake!
    end
  end
end
