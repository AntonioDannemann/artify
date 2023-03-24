import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera-form"
export default class extends Controller {
  initialize() {
    this.html = document.querySelector("html")
    this.body = document.querySelector("body")

    window.onpageshow = () => {
      document.getElementById("loading").classList.add("hidden")
      if (!document.querySelector("#logo")) {
        this.html.classList.remove("noscroll")
        this.body.classList.remove("noscroll")
      }
    }
  }

  submit() {
    this.html.classList.add("noscroll")
    this.body.classList.add("noscroll")
    document.getElementById("loading").classList.remove("hidden")

    setTimeout(() => {
      this.element.submit()
    }, 10)
  }
}
