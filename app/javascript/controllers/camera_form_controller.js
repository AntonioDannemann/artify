import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera-form"
export default class extends Controller {
  submit() {
    document.getElementById("loading").style.display = "flex"

    setTimeout(() => {
      document.getElementById("loading").classList.remove("hidden")
    }, 100)

    this.element.submit()
  }
}
