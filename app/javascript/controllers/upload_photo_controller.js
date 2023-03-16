import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="photo-upload"
export default class extends Controller {
  static targets = ["file", "icon"]

  connect() {
    const children = [...this.fileTarget.children]
    this.first = children.find(e => e.classList.contains("selected-file"))
  }

  addFile(event) {
    const originalInput = event.target
    const originalParent = originalInput.parentNode
    const file = [...originalInput.file]

    this.#showPicture(file, originalInput)

    const newInput = originalInput.cloneNode()
    newInput.value = ""
    originalParent.append(newInput)
  }

  #showPicture(event) {
    const originalInput = event.target
    const url = URL.createObjectURL(originalInput.file)
    selectedFile.style.cssText = `background-image: url(${url});`
    selectedFile.append(originalInput)
  }
}
