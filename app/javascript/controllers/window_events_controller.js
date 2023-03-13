import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="window-events"
export default class extends Controller {
  static targets = ["navbar"]

  initialize() {
    this.#scrollToTopOnReload()
    this.#toggleNavbar()
  }

  #scrollToTopOnReload() {
    if (history.scrollRestoration) {
      history.scrollRestoration = 'manual';
    } else {
        window.onbeforeunload = () => {
            window.scrollTo(0, 0);
        }
    }
  }

  #toggleNavbar() {
    let lastScrollTop = 0

    window.addEventListener("scroll", () => {
      const scrollTop = window.pageYOffset
      if (scrollTop > lastScrollTop) {
        this.navbarTarget.style.maxHeight = "0px"
        this.navbarTarget.style.opacity = 0
        this.navbarTarget.style.padding = "0px 20px"
      } else if (scrollTop < lastScrollTop) {
        this.navbarTarget.style.maxHeight = "55px"
        this.navbarTarget.style.opacity = 1
        this.navbarTarget.style.padding = "10px 20px"
      }
      lastScrollTop = scrollTop
    })
  }
}
