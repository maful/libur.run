import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="users--roles"
export default class extends Controller {
  static values = {
    roles: Array,
    assignments: Array
  }

  connect() {
    console.log('connected', this.assignmentsValue);
  }
}
