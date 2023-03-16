import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    navigator.geolocation.watchPosition(this.#success)
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/navigation-night-v1",
      zoom: -100
    })
    this.#success()
    }

  #success = (location) => {
    const latlng = [location.coords.longitude, location.coords.latitude]
    this.map.flyTo({
      center: latlng,
      essential: true,
      zoom: 13
    })
    new mapboxgl.Marker().setLngLat(latlng).addTo(this.map)
    this.markersValue.forEach((marker) => {
      new mapboxgl.Marker().setLngLat([marker.lng, marker.lat]).addTo(this.map)
    })
  }
}
