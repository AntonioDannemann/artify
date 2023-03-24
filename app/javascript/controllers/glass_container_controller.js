import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["glass", "content", "truncate"]

  toggleGlass() {
    this.glassTarget.classList.toggle("expanded")
    this.truncateTargets.forEach(el => el.classList.toggle("truncate", !this.glassTarget.classList.contains("expanded")))
    if (!this.glassTarget.classList.contains("expanded")) {
      this.contentTarget.scrollTo({ top: 0, behavior: 'smooth' })
    }
  }

  shrinkGlass(event) {
    if (event.target === this.element) {
      this.contentTarget.scrollTo({ top: 0, behavior: 'smooth' })
      this.glassTarget.classList.remove("expanded")
      this.truncateTargets.forEach(el => el.classList.add("truncate"))
    }
  }
}
