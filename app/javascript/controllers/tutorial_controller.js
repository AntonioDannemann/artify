import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tutorial"
export default class extends Controller {
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
      this.element.style.display = "none"
    }, 500);
  }
}
