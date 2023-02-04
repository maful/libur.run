module StreamsHelper
  def custom_action(name, target: nil, content: nil, allow_inferred_rendering: true, attributes: {}, **rendering, &block)
    template = render_template(target, content, allow_inferred_rendering: allow_inferred_rendering, **rendering, &block)

    turbo_stream_action_tag name, target: target, template: template, **attributes
  end

  def reload_turbo_frame(frame_id, **attributes)
    custom_action :reload_turbo_frame, target: frame_id, attributes: attributes
  end
end

Turbo::Streams::TagBuilder.include(StreamsHelper)
