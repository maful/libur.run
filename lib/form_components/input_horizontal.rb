# frozen_string_literal: true

module InputHorizontalComponent
  # To avoid deprecation warning, you need to make the wrapper_options explicit
  # even when they won't be used.
  def support_text(wrapper_options = nil)
    @support_text ||= (options[:support_text].to_s if options[:support_text].present?)
  end
end

SimpleForm.include_component(InputHorizontalComponent)
