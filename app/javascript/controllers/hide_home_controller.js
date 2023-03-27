import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hide-home"
export default class extends Controller {
  disconnect(){
    this.element.style.display = "none"
  }
}
