import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    console.log("connected");
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/navigation-night-v1",
      zoom: 3,
    })

    this.userMarker = new mapboxgl.Marker({ "color" : "#aa3232" })

    this.#addMarkersToMap()
    this.#flyMapToUser()
    navigator.geolocation.watchPosition(this.#updateUserPosition)
  }

  #addMarkersToMap() {


    this.markersValue.forEach(marker => {
      var el = document.createElement('div');
      el.className = 'marker';
      el.style.backgroundImage = `url('${marker.photo}')`;
      console.log(`"url('${marker.photo}')"`);
      new mapboxgl.Marker(
        el
        )
      .setLngLat([marker.lng, marker.lat])
      .setPopup(new mapboxgl.Popup().setHTML("<h1>Hello World!</h1>"))
      .addTo(this.map);
    })
  }

  #flyMapToUser() {
    this.map.flyTo({
      center: [2.294351, 48.858461],
      essential: true,
      zoom: 12
    })
  }

  #updateUserPosition = location => {
    const latlng = [location.coords.longitude, location.coords.latitude]

    this.userMarker.remove()
    this.userMarker.setLngLat(latlng).addTo(this.map)
  }
}
