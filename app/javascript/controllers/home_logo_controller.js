import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-logo"
export default class extends Controller {
  connect() {
    document.querySelector("body").classList.add("noscroll")

    setTimeout(() => {
      this.#hideLogo()
    }, 2000);
  }

  disconnect() {
    document.querySelector("body").classList.remove("noscroll")
  }

  #hideLogo() {
    this.element.style.opacity = "0"
    setTimeout(() => {
      this.element.remove()
    }, 1000);
  }
}
