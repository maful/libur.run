# frozen_string_literal: true
#
# Uncomment this and change the path if necessary to include your own
# components.
# See https://github.com/heartcombo/simple_form#custom-components to know
# more about custom components.
Dir[Rails.root.join('lib/form_components/**/*.rb')].each { |f| require f }
#
# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :default, tag: :div, class: 'input-group' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :pattern
    b.optional :readonly
    b.use :label, class: 'input-group__label'
    b.use :input, class: 'input-group__input', error_class: 'is-invalid'
    b.use :hint, wrap_with: { class: 'input-group__help' }
    b.use :full_error, wrap_with: { tag: 'p', class: 'input-group__error-message' }
  end

  config.wrappers :horizontal_input, tag: :div, class: "input-group input-group--horizontal" do |b|
    b.use :html5
    b.wrapper tag: :div, class: "input-group__text-container" do |ba|
      ba.use :label, class: "input-group__label"
      ba.use :support_text, wrap_with: { tag: :span, class: "input-group__help" }
    end
    b.wrapper tag: :div, class: "input-group__content" do |ba|
      ba.wrapper tag: :div, class: "input-group" do |ca|
        ca.use :placeholder
        ca.optional :pattern
        ca.optional :readonly
        ca.use :input, class: "input-group__input", error_class: "is-invalid"
        ca.use :hint, wrap_with: { class: "input-group__help" }
        ca.use :full_error, wrap_with: { tag: :p, class: "input-group__error-message" }
      end
    end
  end

  config.wrappers :horizontal_select, tag: :div, class: "input-group input-group--horizontal" do |b|
    b.use :html5
    b.wrapper tag: :div, class: "input-group__text-container" do |ba|
      ba.use :label, class: "input-group__label"
      ba.use :support_text, wrap_with: { tag: :span, class: "input-group__help" }
    end
    b.wrapper tag: :div, class: "input-group__content" do |ba|
      ba.wrapper tag: :div, class: "input-group" do |ca|
        ca.use :placeholder
        ca.optional :pattern
        ca.optional :readonly
        ca.use :input, class: "input-group__select", error_class: "is-invalid"
        ca.use :hint, wrap_with: { class: "input-group__help" }
        ca.use :full_error, wrap_with: { tag: :p, class: "input-group__error-message" }
      end
    end
  end

  config.wrappers :input_file, tag: :div, class: 'input-group' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :pattern
    b.optional :readonly
    b.use :label, class: 'input-group__label'
    b.use :input, class: 'input-group__file', error_class: 'is-invalid'
    b.use :hint, wrap_with: { class: 'input-group__help' }
    b.use :full_error, wrap_with: { tag: 'p', class: 'input-group__error-message' }
  end

  config.wrappers :horizontal_input_file, tag: :div, class: "input-group input-group--horizontal" do |b|
    b.use :html5
    b.wrapper tag: :div, class: "input-group__text-container" do |ba|
      ba.use :label, class: "input-group__label"
      ba.use :support_text, wrap_with: { tag: :span, class: "input-group__help" }
    end
    b.wrapper tag: :div, class: "input-group__content input-group__file-container" do |ba|
      ba.optional :preview_image
      ba.wrapper tag: :div, class: "input-group" do |ca|
        ca.use :placeholder
        ca.optional :readonly
        ca.use :input, class: "input-group__file", error_class: "is-invalid"
        ca.use :hint, wrap_with: { class: "input-group__help" }
        ca.use :full_error, wrap_with: { tag: :p, class: "input-group__error-message" }
      end
    end
  end

  config.wrappers :vertical_collection, item_wrapper_tag: :div, item_label_class: 'checkbox__label', tag: :div, class: 'form__group' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'form__label'
    b.use :input, class: 'checkbox__input', error_class: 'is-invalid', valid_class: 'is-valid'
    b.use :hint, wrap_with: { tag: 'div', class: 'form-text' }
    b.use :full_error, wrap_with: { tag: 'p', class: 'form__error' }
  end

  config.wrappers :vertical_boolean, tag: false do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :form_check_wrapper, class: 'form-check' do |bb|
      bb.use :input, class: 'form-check-input', error_class: 'is-invalid', valid_class: 'is-valid'
      bb.use :full_error, wrap_with: { class: 'invalid-feedback' }
    end
    b.use :label, tag: :span, class: 'form__label'
  end

  config.wrappers :vertical_select, class: 'input-group' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'input-group__label'
    b.use :input, class: 'input-group__select', error_class: 'is-invalid'
    b.use :hint, wrap_with: { class: 'input-group__help' }
    b.use :full_error, wrap_with: { tag: 'p', class: 'input-group__error-message' }
  end

  config.wrappers :vertical_radio, item_wrapper_tag: :div, item_wrapper_class: 'input-group__radio-container', item_label_class: 'input-group__radio-label', class: 'input-group input-group--small-horizontal' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'input-group__label'
    b.use :input, class: 'input-group__radio', error_class: 'is-invalid'
    b.use :hint, wrap_with: { class: 'input-group__help' }
    b.use :full_error, wrap_with: { tag: 'p', class: 'input-group__error-message' }
  end

  config.default_wrapper = :horizontal_input
  config.boolean_style = :inline
  config.button_class = 'btn'
  config.error_method = :first
  config.error_notification_tag = :div
  config.error_notification_class = 'error_notification'
  config.label_text = ->(label, _, _) { label }
  config.generate_additional_classes_for = []
  config.browser_validations = false
  config.boolean_label_class = 'checkbox'
  config.wrapper_mappings = {
    boolean: :vertical_boolean,
    check_boxes: :vertical_collection,
    radio_buttons: :vertical_radio,
    select: :horizontal_select,
    file: :horizontal_input_file,
  }
end
