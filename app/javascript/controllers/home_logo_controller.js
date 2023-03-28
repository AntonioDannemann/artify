import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-logo"
export default class extends Controller {
  connect() {
    if (!document.querySelector(".tutorial")) {
      document.querySelector("#pages-home").style.display = "block"
    }

    setTimeout(() => {
      this.#hideLogo()
    }, 2000);
  }

  #hideLogo() {
    this.element.style.opacity = "0"
    if (!document.querySelector(".tutorial")) {
      document.querySelector("html").classList.remove("noscroll")
      document.querySelector("body").classList.remove("noscroll")
    }

    setTimeout(() => {
      this.element.remove()
    }, 1000);
  }
}
