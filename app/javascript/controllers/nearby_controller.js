import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nearby"
export default class extends Controller {
  static targets = ["wrapper"]

  connect() {
    navigator.geolocation.getCurrentPosition(this.#addNearbys)
  }

  #addNearbys = location => {
    console.log(this.wrapperTarget);
    // const lat = 48.858461
    // const lng = 2.294351
    const lat = 49.7719
    const lng = 4.7161
    // const lat = location.coords.latitude
    // const lng = location.coords.longitude
    const url = `/?lat=${lat}&lng=${lng}`

    fetch(url, { headers: { "Accept": "text/plain" } })
      .then(res => res.text())
      .then(html => {
        if (html.includes("card-monument")) {
          this.wrapperTarget.innerHTML = html
        }
      })
  }
}
