import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="glass-container"
export default class extends Controller {
  static targets = ["glass", "content"]
  expand(){
    if (this.glassTarget.classList.contains("expanded")) {
      this.glassTarget.classList.remove("expanded")
      this.contentTarget.scrollTo({top: 0, behavior: 'smooth'})
    } else {
      this.glassTarget.classList.add("expanded")
    }
  }

  hide(event) {
    console.log(event.target);
    console.log(event.target === this.element);
    if (event.target === this.element) {
      this.contentTarget.scrollTo({top: 0, behavior: 'smooth'})
      this.glassTarget.classList.remove("expanded")
    }
  }
}
