import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-to-featured"
export default class extends Controller {
  connect() {
    this.featured = document.getElementById('featured')
  }

  scrollToFeatured() {
    window.scroll({ top: this.featured.offsetTop , left: 0, behavior: "smooth" })
  }
}
