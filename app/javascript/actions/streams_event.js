import { Turbo } from "@hotwired/turbo-rails"

Turbo.StreamActions.reload_turbo_frame = function () {
  const frameId = this.target;
  const frameSrc = this.getAttribute("src");
  const selector = `turbo-frame#${frameId}`;
  const frameElement = document.querySelector(selector);
  if (frameElement) {
    if (frameSrc !== null) {
      frameElement.src = frameSrc;
    }

    try {
      frameElement.reload();
    } catch (e) {
      console.error('Unable to reload the frame element', e);
    }
  }
};
