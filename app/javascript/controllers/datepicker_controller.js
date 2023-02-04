import { Controller } from "@hotwired/stimulus"
import { Datepicker } from "flowbite-datepicker"

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = ["input"]

  static values = {
    format: { type: String, default: "yyyy-mm-dd" },
    autohide: { type: Boolean, default: true },
    todayBtn: { type: Boolean, default: false },
  }

  connect() {
    this.datepicker = new Datepicker(this.inputTarget, {
      autohide: this.autohideValue,
      format: this.formatValue,
      todayBtn: this.todayBtnValue,
    })
  }

  disconnect() {
    this.datepicker.destroy()
  }
}
