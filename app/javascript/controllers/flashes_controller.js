import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flashes"
export default class extends Controller {
  connect() {
    this.slideAlert()
  }

  slideAlert() {
    this.element.classList.remove("hidden")

    setTimeout(() => {
      this.element.classList.add("hidden")
    }, 3500)

    setTimeout(() => {
      this.element.remove()
    }, 7000)
  }
}
