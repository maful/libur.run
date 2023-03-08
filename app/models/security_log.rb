# frozen_string_literal: true

class SecurityLog < ::PublicActivity::Activity
  include ClearCacheCollection
end
