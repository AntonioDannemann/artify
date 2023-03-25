import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    const blinder = document.getElementById('blinder')
    const featureListing = document.getElementById('feature-listing')
    const geojson = JSON.stringify(this.markersValue[0]);

    navigator.geolocation.getCurrentPosition(this.#flyMapToUser);
    navigator.geolocation.getCurrentPosition(location => {
      const lat = location.coords.latitude
      const lng = location.coords.longitude

      this.map.on('click', 'monument', (e) => {
        blinder.classList.add('blinder-expanded')
        featureListing.classList.add('listing-expanded')
        featureListing.innerHTML = ""
        const mon = e.features[0].properties;
        const url = `/monuments?lat=${lat}&lng=${lng}&id=${mon.id}`

        fetch(url, { headers: { "Accept": "text/plain" } })
          .then(res => res.text())
          .then(html => {
            featureListing.innerHTML = html
          })
      });

    });


    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/navigation-night-v1",
      zoom: -5,
    })

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



    blinder.addEventListener('click', (e) => {
      blinder.classList.remove('blinder-expanded')
      featureListing.classList.remove('listing-expanded')
    })

    this.map.on('movestart', () => {
      blinder.classList.remove('blinder-expanded')
      featureListing.classList.remove('listing-expanded')
    });


    this.map.addControl(
      new mapboxgl.GeolocateControl({
      positionOptions: {
      enableHighAccuracy: true
      },

      trackUserLocation: true,

      showUserHeading: true
      })
      );
  }

  #flyMapToUser = position =>  {
    this.map.flyTo({
      center: [position.coords.longitude, position.coords.latitude, ],
      essential: true,
      zoom: 12
    })
  }
}
