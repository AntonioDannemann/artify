import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-logo"
export default class extends Controller {
  connect() {
    if (!document.querySelector(".tutorial")) {
      document.querySelector("#pages-home").style.display = "block"
    }

    setTimeout(() => {
      this.#hideLogo()
    }, 3000);
  }

  #hideLogo() {
    this.element.style.opacity = "0"

    setTimeout(() => {
      this.element.remove()
    }, 1000);
  }
}
