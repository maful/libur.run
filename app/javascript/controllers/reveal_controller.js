import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reveal"
export default class extends Controller {
  static values = { removeOnHide: { type: Boolean, default: true } }
  static targets = ["elm"]
  static classes = ["hidden"]

  connect() {
    this.class = this.hasHiddenClass ? this.hiddenClass : "hidden"
  }

  hide() {
    this.elmTargets.forEach((elm) => {
      elm.classList.add(this.class)
    })
  }
}
