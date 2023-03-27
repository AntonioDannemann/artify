import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  static targets = ["map", "listing", "blinder"]

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    const geojson = JSON.stringify(this.markersValue[0]);

    // navigator.geolocation.getCurrentPosition(this.#flyMapToUser);
    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/mapbox/navigation-night-v1",
      zoom: -5,
    })

    navigator.geolocation.getCurrentPosition(location => {
      this.map.flyTo({
        center: [location.coords.longitude, location.coords.latitude, ],
        essential: true,
        zoom: 12
      })
      const lat = location.coords.latitude
      const lng = location.coords.longitude

      this.map.on('click', 'monument', event => {
        this.blinderTarget.classList.add('blinder-expanded')
        const mon = event.features[0].properties;
        const url = `/monuments?lat=${lat}&lng=${lng}&id=${mon.id}`

        fetch(url, { headers: { "Accept": "text/plain" } })
          .then(res => res.text())
          .then(html => {
            this.listingTarget.innerHTML = html
            this.listingTarget.classList.remove('listing-hidden')
          })
      });

    });

    this.map.on('load', () => {
      this.map.loadImage(
        "/assets/location_pin-426cf5b931d1f7c30012d7662bfd0ad73b4b72e1667f9846706332a375a04000.png",
        // <%# <%= image_path "location-pin.png" %>
        (error, image) => {
        if (error) throw error;

        this.map.addImage('pin', image);

        this.map.addSource("monuments", {
          type: "geojson",
          data: JSON.parse(geojson)
        });
        this.map.addLayer({
          'id': 'monument',
          'source': 'monuments',
          'type': 'symbol',
          'layout': {
            "icon-allow-overlap" : true,
            "icon-padding" : 10,
            'icon-image': 'pin',
            "icon-size": ['interpolate', ['linear', 2], ['zoom'], 2, 0.04, 10, 0.025, 12, 0.04]
            }
        });
      });
    });

    this.map.on('movestart', () => {
      this.blinderTarget.classList.remove('blinder-expanded')
      this.listingTarget.classList.add('listing-hidden')
    });

    const geolocate = new mapboxgl.GeolocateControl({
      positionOptions: {
      enableHighAccuracy: true
      },
      trackUserLocation: true
      })
    this.map.addControl(geolocate);
  }

  lower() {
    this.blinderTarget.classList.remove('blinder-expanded')
    this.listingTarget.classList.add('listing-hidden')
  }
}
