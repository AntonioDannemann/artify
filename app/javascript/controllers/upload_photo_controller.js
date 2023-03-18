import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="photo-upload"
export default class extends Controller {
  static targets = ["label"]

  showPicture(event) {
    const file = event.target.files[0]
    const url = URL.createObjectURL(file)
    this.labelTarget.style.backgroundImage = `url(${url})`
  }
}
