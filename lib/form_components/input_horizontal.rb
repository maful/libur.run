# frozen_string_literal: true

module InputHorizontalComponent
  # To avoid deprecation warning, you need to make the wrapper_options explicit
  # even when they won't be used.
  def support_text(wrapper_options = nil)
    @support_text ||= (options[:support_text].to_s if options[:support_text].present?)
  end

  def preview_image(wrapper_options = nil)
    tag.div(template.image_tag(options[:preview_image], alt: "preview image", class: options[:preview_image_class]))
  end
end

SimpleForm.include_component(InputHorizontalComponent)
