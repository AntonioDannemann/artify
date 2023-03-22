import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    const geojson = JSON.stringify(this.markersValue[0]);
    const features = this.markersValue[0].features

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/navigation-night-v1",
      zoom: -5,
    })

    navigator.geolocation.getCurrentPosition(this.#flyMapToUser);

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

      const el = document.createElement('a');
      el.href = `monuments/${feature.properties.id}`
      el.className = 'marker';
      el.style.backgroundImage = `url('${feature.properties.photo}')`;

      new mapboxgl.Marker(el)
      .setLngLat(feature.geometry.coordinates)
      .addTo(this.map);
    }

    this.map.on('moveend', () => {
      const visible = this.map.queryRenderedFeatures({ layers: ['monument'] });
      if (visible.length) {
        this.#renderListings(visible)
      }else {
         const listingEl = document.getElementById('feature-listing')
         listingEl.innerHTML = ""
         const emptyItem = document.createElement('div')
         emptyItem.className = 'card-monument shadow-monument';
         emptyItem.textContent = 'scroll to find monuments';
         emptyItem.style.backgroundImage = `url('https://newfoundtrees.org/static/media/doge.3636fa73.jpg')`
         listingEl.appendChild(emptyItem);
      }
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
    console.log(position.coords);
    this.map.flyTo({
      center: [position.coords.longitude, position.coords.latitude, ],
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
        itemLink.href = `monuments/${monument.properties.id}`;
        itemLink.textContent = monument.properties.name;
        itemLink.style.backgroundImage = `url('${monument.properties.photo}')`
        listingEl.appendChild(itemLink);
      }
    }
  }
}
