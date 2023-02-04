import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alert"
export default class extends Controller {
  static classes = ["hidden"]

  connect() {
    this.class = this.hasHiddenClass ? this.hiddenClass : "hidden"
  }

  hide() {
    this.element.classList.add(this.class)
  }

  remove() {
    this.hide()
    this.element.remove()
  }
}
