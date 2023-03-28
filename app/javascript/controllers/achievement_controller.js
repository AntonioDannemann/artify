import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="achievement"
export default class extends Controller {
  remove() {
    this.element.remove()
  }
}
