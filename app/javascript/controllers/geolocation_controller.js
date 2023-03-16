import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="geolocation"
export default class extends Controller {
  connect() {
    console.log("Would it work?");
    const geo = navigator.geolocation
    geo.watchPosition(this.#getLatLng.bind(this))
    this.#getLatLng
  }

  #getLatLng(location) {
    const lat = location.coords.latitude
    const lng = location.coords.longitude
    const latitudeInput = document.getElementById('latitude');
    const longitudeInput = document.getElementById('longitude');
    latitudeInput.value = lat;
    longitudeInput.value = lng;
    console.log(latitudeInput.value);
    console.log(longitudeInput.value);
  }
}
