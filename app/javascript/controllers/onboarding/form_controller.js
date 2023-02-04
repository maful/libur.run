import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="onboarding--form"
export default class extends Controller {
  static targets = ["form"];

  submit() {
    this.formTarget.requestSubmit();
  }
}
