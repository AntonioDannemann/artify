import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-logo"
export default class extends Controller {
  connect() {
    this.html = document.querySelector("html")
    this.body = document.querySelector("body")

    this.html.classList.add("noscroll")
    this.body.classList.add("noscroll")

    document.querySelector("#pages-home").style.display = "block"

    setTimeout(() => {
      this.#hideLogo()
    }, 2000);
  }

  #hideLogo() {
    this.element.style.opacity = "0"
    if (!document.querySelector(".tutorial")) {
      this.html.classList.remove("noscroll")
      this.body.classList.remove("noscroll")
    }

    setTimeout(() => {
      this.element.remove()
    }, 1000);
  }
}
