import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="installation--license-form"
export default class extends Controller {
  agree(e) {
    const nextButton = document.getElementById("submit_license_form")

    if (e.target.checked === true) {
      nextButton.removeAttribute("disabled")
    } else {
      nextButton.setAttribute("disabled", true)
    }
  }
}
