import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="achievement"
export default class extends Controller {
  static targets = ["details"]

  toggleDetails(event) {
    const details = event.target.nextElementSibling
    console.log(details.style.display);
    if (details.style.display === "") {
      this.detailsTargets.forEach(details => details.style.display = "")
      details.style.display = "block"
    } else {
      this.detailsTargets.forEach(details => details.style.display = "")
    }
  }

  remove() {
    this.element.remove()
  }
}
