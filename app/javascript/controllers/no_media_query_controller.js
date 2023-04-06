import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="no-media-query"
export default class extends Controller {
  connect() {
    let isMobile = /Android|webOS|iPhone|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
    this.element.style.display = window.innerWidth < 576  || isMobile ? "none" : "block"

    window.addEventListener("resize", () => {
      isMobile = /Android|webOS|iPhone|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
      if (window.innerWidth < 576 || isMobile) {
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
