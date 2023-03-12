import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-logo"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.#hideLogo()
    }, 2000);
  }

  #hideLogo() {
    this.element.style.opacity = "0"
    setTimeout(() => {
      this.element.remove()
    }, 1000);
  }
}
