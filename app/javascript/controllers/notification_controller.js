import { Controller } from "@hotwired/stimulus"
import { useTransition } from "stimulus-use"

// Connects to data-controller="notification"
export default class extends Controller {
  static targets = ["message"]

  static values = {
    delay: {
      type: Number,
      default: 3000
    },
    hidden: {
      type: Boolean,
      default: false
    },
    removeLater: {
      type: Boolean,
      default: true
    }
  }

  initialize() {
    this.hide = this.hide.bind(this)
  }

  connect() {
    useTransition(this)

    if (this.hiddenValue === false) {
      this.show()
    }
  }

  show(e) {
    if (this.hasMessageTarget && typeof e !== 'undefined' && e.detail.message) {
      this.messageTarget.textContent = e.detail.message
    }

    this.enter()

    this.timeout = setTimeout(this.hide, this.delayValue)
  }

  async hide() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    if (this.hasMessageTarget) {
      // reset message content
      this.messageTarget.textContent = ""
    }

    await this.leave()

    if (this.removeLaterValue) {
      this.element.remove()
    }
  }
}
