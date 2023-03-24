import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    console.log("hello");
    mapboxgl.accessToken = this.apiKeyValue
    const blinder = document.getElementById('blinder')
    const featureListing = document.getElementById('feature-listing')
    const geojson = JSON.stringify(this.markersValue[0]);
    // const features = this.markersValue[0].features

    navigator.geolocation.getCurrentPosition(this.#flyMapToUser);

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/navigation-night-v1",
      zoom: -5,
    })

    this.map.on('load', () => {
      this.map.loadImage(
        'https://cdn.pixabay.com/photo/2013/07/13/11/54/location-158934_1280.png',
        // 'http://localhost:3000/assets/pin.png',
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
            'icon-image': 'pin',
            "icon-size": ['interpolate', ['linear', 2], ['zoom'], 2, 0.04, 10, 0.025, 12, 0.04]
            }
        });
      });
    });

    this.map.on('click', 'monument', (e) => {
      e.preventDefault()
      blinder.style.bottom = '270px';
      blinder.style.backgroundColor =   'rgba(154, 180, 149, 1)';

      featureListing.style.height = '285px';
      featureListing.style.bottom = '0%';
      featureListing.innerHTML = ""

      const mon = e.features[0].properties;
      const indexCard = document.createElement('div')
      indexCard.innerHTML =`
      <div class="card-index">
        <div class="image-index" style="background-image: linear-gradient(rgba(0, 0, 0, 0.2) 30%, rgba(0, 0, 0, 0.7)), url('${mon.photo}')">
        </div>
        <div class="description-index">
          <div>
            <h3>${mon.name}</h3>
            <p><i class="fa-solid fa-location-dot"></i>  ${mon.city} </p>
          </div>
          <p class="desc-short">${mon.desc}...</p>
          <a href="/monuments/1"> Learn more <i class="fa-solid  fa-arrow-right"></i></a>
        </div>
      </div>
      `;
      featureListing.appendChild(indexCard);
    });

    blinder.addEventListener('click', (e) => {
      blinder.style.bottom = '-.5%';
      blinder.style.backgroundColor =   'rgba(154, 180, 149, 0)';

      featureListing.style.position = 'fixed';
      featureListing.style.height = '0%';
      featureListing.style.bottom = '-5%'
    })

    this.map.on('movestart', () => {
      blinder.style.bottom = '-.5%';
      blinder.style.backgroundColor =   'rgba(154, 180, 149, 0)';

      featureListing.style.position = 'fixed';
      featureListing.style.height = '0%';
      featureListing.style.bottom = '-5%'
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
