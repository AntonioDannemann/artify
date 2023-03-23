import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-logo"
export default class extends Controller {
  connect() {
    this.html = document.querySelector("html")
    this.body = document.querySelector("body")

    this.html.classList.add("noscroll")
    this.body.classList.add("noscroll")

    setTimeout(() => {
      this.#hideLogo()
    }, 2000);
  }

  disconnect() {
    if (!document.querySelector(".tutorial")) {
      this.html.classList.remove("noscroll")
      this.body.classList.remove("noscroll")
    }
  }

  #hideLogo() {
    this.element.style.opacity = "0"
    setTimeout(() => {
      this.element.remove()
    }, 1000);
  }
}
