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

    const geojson = JSON.stringify(this.markersValue[0]);
    const features = this.markersValue[0].features

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/navigation-night-v1",
      zoom: -5,
    })

    this.map.on('load', () => {
      this.map.addSource("monuments", {
        type: "geojson",
        data: JSON.parse(geojson)
      });
      this.map.addLayer({
        'id': 'monument',
        'source': 'monuments',
        'type': 'circle',
        'paint': {
        'circle-color': '#4264fb',
        'circle-radius': 4,
        },
      });
    });


    for (const feature of features) {

      const el = document.createElement('div');
      el.className = 'marker';
      el.style.backgroundImage = `url('${feature.properties.photo}')`;

      const popup = new mapboxgl.Popup({ offset: 30, closeButton: false })
      .setText( feature.properties.name);

      new mapboxgl.Marker(el)
      .setLngLat(feature.geometry.coordinates)
      .setPopup(popup)
      .addTo(this.map);
    }

    this.map.on('moveend', () => {
      const visible = this.map.queryRenderedFeatures({ layers: ['monument'] });
      if (visible.length) {
        this.#renderListings(visible)
      }
    });

    this.map.addControl(
      new mapboxgl.GeolocateControl({
      positionOptions: {
      enableHighAccuracy: true
      },
      // When active the map will receive updates to the device's location as it changes.
      trackUserLocation: true,
      // Draw an arrow next to the location dot to indicate which direction the device is heading.
      showUserHeading: true
      })
      );

    this.#flyMapToUser()
  }

  #home = location => {
    const latlng = [location.coords.longitude, location.coords.latitude]

    this.map.flyTo({
      center: latlng,
      essential: true,
      zoom: 12
    })
  }

  flyHome() {
    navigator.geolocation.watchPosition(this.#home);
  }

  #flyMapToUser() {
    this.map.flyTo({
      center: [2.294351, 48.858461],
      essential: true,
      zoom: 12
    })
  }

  #renderListings(monuments) {
    const listingEl = document.getElementById('feature-listing');
    listingEl.innerHTML = '';
    if (monuments.length) {
      for (const monument of monuments) {
        const itemLink = document.createElement('a');
        itemLink.className = 'card-monument shadow-monument';
        itemLink.href = "www.google.com";
        itemLink.target = '_blank';
        itemLink.textContent = monument.properties.name;
        itemLink.style.backgroundImage = `url('${monument.properties.photo}')`
        listingEl.appendChild(itemLink);
      }
    }
    else {
      listingEl.innerHTML = 'No results';
    }
  }
}
