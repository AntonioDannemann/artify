import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tutorial"
export default class extends Controller {
  connect() {
    this.html = document.querySelector("html")
    this.body = document.querySelector("body")

    this.html.classList.add("noscroll")
    this.body.classList.add("noscroll")
  }

  disconnect() {
    this.html.classList.remove("noscroll")
    this.body.classList.remove("noscroll")
  }

  hideStep(event) {
    const card = event.target.parentElement.parentElement
    card.style.opacity = "0"
    setTimeout(() => {
      card.style.display = "none"
    }, 500);
  }

  skipTutorial() {
    this.element.style.opacity = "0"
    setTimeout(() => {
      this.element.remove()
    }, 500);
  }
}
