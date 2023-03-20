import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera-form"
export default class extends Controller {
  initialize() {
    window.onpageshow = () => {
      document.getElementById("loading").classList.add("hidden")
    }
  }

  submit() {
    document.getElementById("loading").classList.remove("hidden")

    setTimeout(() => {
      this.element.submit()
    }, 10)
  }
}
