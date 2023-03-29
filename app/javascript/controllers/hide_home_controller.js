import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hide-home"
export default class extends Controller {
  connect() {
    if (!document.querySelector("#logo")) location.reload()
  }

  disconnect() {
    this.element.style.display = "none"
  }
}
