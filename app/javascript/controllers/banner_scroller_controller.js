import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="banner-scroller"
export default class extends Controller {
  connect() {
    this.vh = window.innerHeight * 2.8
    this.#pageScroll()
  }

  static targets = ["image"]

  #pageScroll = () => {
    this.element.scrollBy({left: 2, behavior: "smooth"})

    if (this.element.scrollLeft > this.vh * 0.7 && this.imageTargets.length < 2) {
      this.element.append(this.imageTarget.cloneNode())
    }

    if (this.element.scrollLeft > this.vh * 1.1) {
      this.imageTarget.remove()
      this.element.scrollLeft = this.vh * 0.1 + 105
    }

    setTimeout(this.#pageScroll, 30)
  }
}
