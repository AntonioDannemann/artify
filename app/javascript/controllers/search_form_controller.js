import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ["form", "input", "list", "wrapper"]

  update() {
    const url = `${this.formTarget.action}?search=${this.inputTarget.value}`
    fetch(url, {
      headers: { "Accept": "text/plain" }
    }).then(res => res.text())
      .then(html => {
        this.listTarget.outerHTML = html

        if (this.listTarget.childNodes.length > 1) {
          this.wrapperTarget.style.maxHeight = "370px"
          this.wrapperTarget.style.opacity = "1"
        } else {
          this.wrapperTarget.style.maxHeight = "0"
          this.wrapperTarget.style.opacity = "0"
        }
      })
  }
}
