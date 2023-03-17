import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/dark-v11",
      zoom: 3,
    })

    this.userMarker = new mapboxgl.Marker({ "color" : "#aa3232" })

    this.#addMarkersToMap()
    navigator.geolocation.watchPosition(this.#flyMapToUser)
  }

  #addMarkersToMap() {
    this.markersValue.forEach(marker => {
      new mapboxgl.Marker({ "color": "#9ab495" }).setLngLat([marker.lng, marker.lat]).addTo(this.map)
    })
  }

  #flyMapToUser = location => {
    const latlng = [location.coords.longitude, location.coords.latitude]

    this.userMarker.remove()
    this.userMarker.setLngLat(latlng).addTo(this.map)

    this.map.flyTo({
      center: latlng,
      essential: true,
      zoom: 13
    })
  }
}
