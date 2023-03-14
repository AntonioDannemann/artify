import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="switch-account-form"
export default class extends Controller {
  static targets = ["button", "form"]
  static values = {
    sessionForm: String,
    registrationForm: String
  }

  connect() {
    console.log("a");
  }

  switchForm(event) {
    if (!event.target.classList.contains("active")) {
      this.buttonTargets.forEach(e => e.classList.toggle("active"))
      this.formTargets.forEach(e => e.classList.toggle("hidden"))
    }
  }
}
