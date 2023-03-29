import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  static targets = ["listing", "map", "overlay"]

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/mapbox/navigation-night-v1",
      zoom: 0,
    })

    this.map.on("load", () => {
      this.#addMarkersToMap()
      this.#addGeolocationToMap()
    })

    navigator.geolocation.getCurrentPosition(this.#flyMapToUser)

    this.map.on('click', 'monument', this.#fetchMonument)
    this.map.on('movestart', this.hideOverlay)
  }

  hideOverlay = () => {
    this.overlayTarget.classList.add('hidden')
  }

  #addGeolocationToMap() {
    const geolocate = new mapboxgl.GeolocateControl({
      positionOptions: {
        enableHighAccuracy: true
      },
      trackUserLocation: true
    })

    this.map.addControl(geolocate)
  }

  #addMarkersToMap() {
    const path = "/assets/location_pin-426cf5b931d1f7c30012d7662bfd0ad73b4b72e1667f9846706332a375a04000.png"
    this.map.loadImage(path, (error, image) => {
      if (error) throw error

      this.map.addImage('pin', image)

      const geojson = JSON.stringify(this.markersValue[0])
      this.map.addSource("monuments", {
        type: "geojson",
        data: JSON.parse(geojson)
      })

      this.map.addLayer({
        'id': 'monument',
        'source': 'monuments',
        'type': 'symbol',
        'layout': {
          "icon-allow-overlap": true,
          "icon-padding": 10,
          'icon-image': 'pin',
          "icon-size": ['interpolate', ['linear', 2], ['zoom'], 2, 0.04, 10, 0.025, 12, 0.04]
        }
      })
    })
  }

  #fetchMonument = event => {
    const mon = event.features[0].properties
    const url = `/monuments?lat=${this.lat}&lng=${this.lng}&id=${mon.id}`

    fetch(url, { headers: { "Accept": "text/plain" } })
      .then(res => res.text())
      .then(html => {
        this.listingTarget.innerHTML = html
        this.overlayTarget.classList.remove('hidden')
      })
  }

  #flyMapToUser = location => {
    this.map.flyTo({
      center: [location.coords.longitude, location.coords.latitude, ],
      essential: true,
      zoom: 12
    })
  }
}
