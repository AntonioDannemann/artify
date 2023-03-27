import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["glass", "content", "truncate"]

  connect() {
    this.html = document.querySelector("html")
    this.body = document.querySelector("body")

    this.html.classList.add("noscroll")
    this.body.classList.add("noscroll")
  }

  toggleGlass() {
    this.glassTarget.classList.toggle("expanded")
    this.contentTarget.scrollTo({ top: 0 })

    if (this.glassTarget.classList.contains("expanded")) {
      this.truncateTarget.classList.remove("truncate")
    } else {
      setTimeout(() => {
        this.truncateTarget.classList.add("truncate")
      }, 450);
    }
  }

  shrinkGlass(event) {
    if (event.target === this.element) {
      this.contentTarget.scrollTo({ top: 0 })
      this.glassTarget.classList.remove("expanded")

      setTimeout(() => {
        this.truncateTarget.classList.add("truncate")
      }, 450);
    }
  }
}
