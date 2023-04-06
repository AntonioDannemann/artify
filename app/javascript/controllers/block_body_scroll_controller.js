import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="block-body-scroll"
export default class extends Controller {
  connect() {
      this.html = document.querySelector("html")
      this.html.classList.add("noscroll")

      this.body = document.querySelector("body")
      this.body.classList.add("noscroll")
  }

  disconnect() {
    if(!document.querySelector(".tutorial") && document.querySelector(".no-media-query").style.display === "none") {
      this.html.classList.remove("noscroll")
      this.body.classList.remove("noscroll")
    }
  }
}
