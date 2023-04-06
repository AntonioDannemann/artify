import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="no-media-query"
export default class extends Controller {
  connect() {
    console.log(navigator.userAgentData.mobile);
    this.element.style.display = window.innerWidth < 576  || navigator.userAgentData.mobile ? "none" : "block"

    window.addEventListener("resize", () => {
      if (window.innerWidth < 576 || navigator.userAgentData.mobile) {
        this.element.style.display = "none"

        document.querySelector("html").classList.remove("noscroll")
        document.querySelector("body").classList.remove("noscroll")
      } else {
        this.element.style.display = "block"

        document.querySelector("html").classList.add("noscroll")
        document.querySelector("body").classList.add("noscroll")
      }
    })
  }
}
