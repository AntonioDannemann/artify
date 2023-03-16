import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="geolocation"
export default class extends Controller {
  connect() {
    console.log("geolocation connected");
    const geo = navigator.geolocation
    geo.watchPosition(this.#getLatLng.bind(this))
  }

  #getLatLng(location) {
    const coords = [location.coords.latitude, location.coords.longitude]

    console.log(coords)
    document.getElementById('userlocation').value=coords
  }
}
