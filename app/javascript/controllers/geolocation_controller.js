import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="geolocation"
export default class extends Controller {
  connect() {
    const geo = navigator.geolocation
    geo.watchPosition(this.#getLatLng.bind(this))
  }

  #getLatLng(location) {
    const lat = location.coords.latitude
    const lng = location.coords.longitude

    console.log(lat, lng)
  }
}
