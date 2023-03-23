import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["glass", "content", "truncate"]

  expand(){
    if (this.glassTarget.classList.contains("expanded")) {
      this.glassTarget.classList.remove("expanded")
      this.contentTarget.scrollTo({top: 0, behavior: 'smooth'})
      this.truncateTargets.forEach(el => el.classList.add("truncate"))
    } else {
      this.glassTarget.classList.add("expanded")
      this.truncateTargets.forEach(el => el.classList.remove("truncate"))
    }
  }

  hide(event) {
    if (event.target === this.element) {
      this.contentTarget.scrollTo({top: 0, behavior: 'smooth'})
      this.glassTarget.classList.remove("expanded")
      this.truncateTargets.forEach(el => el.classList.add("truncate"))
    }
  }
}
