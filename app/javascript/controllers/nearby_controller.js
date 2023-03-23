import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nearby"
export default class extends Controller {
  static targets = ["wrapper"]

  connect() {
    navigator.geolocation.getCurrentPosition(this.#addNearbys)
  }

  #addNearbys = location => {
    const lat = location.coords.latitude
    const lng = location.coords.longitude
    const url = `/?lat=${lat}&lng=${lng}`

    fetch(url, { headers: { "Accept": "text/plain" } })
      .then(res => res.text())
      .then(html => {
          this.wrapperTarget.innerHTML = html
      })
  }
}
