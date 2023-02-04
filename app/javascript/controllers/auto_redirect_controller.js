import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="auto-redirect"
export default class extends Controller {
  static values = {
    delay: { type: Number, default: 5000 },
    path: String,
    action: { type: String, default: "advance" },
  }

  connect() {
    setTimeout(() => {
      Turbo.visit(this.pathValue, { action: this.actionValue })
    }, this.delayValue)
  }
}
