import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="achievement"
export default class extends Controller {
  static targets = ["details"]

  connect() {
    window.addEventListener("scroll", () => {
      this.detailsTargets.forEach(details => details.classList.add("hidden"))
    })
  }

  toggleDetails(event) {
    const details = event.target.nextElementSibling
    if (details.classList.contains("hidden")) {
      this.detailsTargets.forEach(details => details.classList.add("hidden"))
      details.classList.remove("hidden")
    } else {
      details.classList.add("hidden")
    }
  }

  remove() {
    this.element.remove()
  }
}
