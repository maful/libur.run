# frozen_string_literal: true

module ClearCacheCollection
  extend ActiveSupport::Concern

  included do
    after_create :clear_cache_collection
    after_destroy :clear_cache_collection
  end

  def clear_cache_collection
    Rails.cache.delete_matched("pagy-#{self.class.model_name.collection}*")
  end
end
