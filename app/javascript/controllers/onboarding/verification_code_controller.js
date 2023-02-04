import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="onboarding--verification-code"
export default class extends Controller {
  static targets = ['input'];

  connect() {
    // Prevent user for being input multple number in one field
    this.inputTargets.forEach((input) => {
      input.addEventListener("input", () => {
        const inputLength = input.value.length;
        const nextElementSibling = input.nextElementSibling;

        if (nextElementSibling && inputLength === 1) {
          nextElementSibling.focus();
        }
      });
    });
  }
}
