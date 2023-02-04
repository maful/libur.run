import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="onboarding--form-address"
export default class extends Controller {
  static targets = ["state", "city"]

  async countryChange(e) {
    this.stateTarget.setAttribute("disabled", true)
    this.cityTarget.setAttribute("disabled", true)

    const params = new URLSearchParams()
    this.countryCode = e.target.selectedOptions[0].value
    params.append("country", this.countryCode)
    params.append("target", this.stateTarget.id)

    const response = await get(`/onboarding/states?${params}`, {
      responseKind: "turbo-stream"
    })
    if (response.ok) {
      this.stateTarget.removeAttribute("disabled")
    }
  }

  async stateChange(e) {
    this.cityTarget.setAttribute("disabled", true)

    const params = new URLSearchParams()
    params.append("country", this.countryCode)
    params.append("state", e.target.selectedOptions[0].value)
    params.append("target", this.cityTarget.id)

    const response = await get(`/onboarding/cities?${params}`, {
      responseKind: "turbo-stream"
    })
    if (response.ok) {
      this.cityTarget.removeAttribute("disabled")
    }
  }
}
