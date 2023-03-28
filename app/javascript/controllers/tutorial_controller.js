import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tutorial"
export default class extends Controller {
  disconnect() {
    document.querySelector("html").classList.remove("noscroll")
    document.querySelector("body").classList.remove("noscroll")
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
