import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["glass", "content", "truncate"]

  toggleGlass() {
    this.glassTarget.classList.toggle("expanded")
    this.truncateTarget.classList.toggle("truncate")
    this.contentTarget.scrollTo({ top: 0, behavior: 'smooth' })
  }

  shrinkGlass(event) {
    if (event.target === this.element) {
      this.contentTarget.scrollTo({ top: 0, behavior: 'smooth' })
      this.glassTarget.classList.remove("expanded")
      this.truncateTarget.classList.toggle("truncate")
    }
  }
}
