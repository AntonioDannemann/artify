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
    const features = this.markersValue[0].features

    navigator.geolocation.getCurrentPosition(this.#flyMapToUser);

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/navigation-night-v1",
      zoom: -5,
    })



    this.map.on('load', () => {
      this.map.loadImage(
        'https://docs.mapbox.com/mapbox-gl-js/assets/cat.png',
        (error, image) => {
        if (error) throw error;

        // Add the image to the map style.
        this.map.addImage('cat', image);

        this.map.addSource("monuments", {
          type: "geojson",
          data: JSON.parse(geojson)
        });
        this.map.addLayer({
          'id': 'monument',
          'source': 'monuments',
          'type': 'symbol',
          'layout': {
            'icon-image': 'cat',
            'icon-size': 0.25
            }
        });
      });
    })

    this.map.on('click', 'monument', (e) => {
      blinder.style.bottom = '30.2%';
      blinder.style.backgroundColor =   'rgba(154, 180, 149, 1)';
      featureListing.style.height = '32%';
      featureListing.style.bottom = '0%';
      const mon = e.features[0].properties;
      featureListing.innerHTML = ""
         const indexCard = document.createElement('a')
         indexCard.href = `monuments/${mon.id}`
         indexCard.className = 'card-monument shadow-monument';
         indexCard.textContent = `${mon.name}`;
         indexCard.style.backgroundImage = `url('${mon.photo}')`
         featureListing.appendChild(indexCard);
    });

    blinder.addEventListener('click', (e) => {
      blinder.style.bottom = '-.5%';
      blinder.style.backgroundColor =   'rgba(154, 180, 149, 0)';
      featureListing.style.height = '0%';
      featureListing.style.bottom = '-5%'
    })


    this.map.addControl(
      new mapboxgl.GeolocateControl({
      positionOptions: {
      enableHighAccuracy: true
      },

      trackUserLocation: true,

      showUserHeading: true
      })
      );

    // for (const feature of features) {

    //   const el = document.createElement('div');
    //   el.className = 'marker';
    //   el.style.backgroundImage = `url('https://cdn-icons-png.flaticon.com/512/263/263429.png')`;

    //   const popup = new mapboxgl.Popup({ closeButton: false })
    //   popup.setText(feature.properties.name);

    //   new mapboxgl.Marker(el)
    //   .setLngLat(feature.geometry.coordinates)
    //   .setPopup(popup)
    //   .addTo(this.map);
    // }

    // this.map.on('moveend', () => {
    //   const visible = this.map.queryRenderedFeatures({ layers: ['monument'] });
    //   if (visible.length) {
    //     this.#renderListings(visible)
    //   }else {
    //      const listingEl = document.getElementById('feature-listing')
        //  listingEl.innerHTML = ""
        //  const emptyItem = document.createElement('div')
        //  emptyItem.className = 'card-monument shadow-monument';
        //  emptyItem.textContent = 'scroll to find monuments';
        //  emptyItem.style.backgroundImage = `url('https://newfoundtrees.org/static/media/doge.3636fa73.jpg')`
        //  listingEl.appendChild(emptyItem);
    //   }
    // });

  }

  #flyMapToUser = position =>  {
    this.map.flyTo({
      center: [position.coords.longitude, position.coords.latitude, ],
      essential: true,
      zoom: 12
    })
  }

  // #renderListings(monuments) {
  //   const listingEl = document.getElementById('feature-listing');
  //   listingEl.innerHTML = '';

  //   if (monuments.length) {
  //     for (const monument of monuments) {
  //       const itemLink = document.createElement('a');
  //       itemLink.className = 'card-monument shadow-monument';
  //       itemLink.href = `monuments/${monument.properties.id}`;
  //       itemLink.textContent = monument.properties.name;
  //       itemLink.style.backgroundImage = `url('${monument.properties.photo}')`
  //       listingEl.appendChild(itemLink);
  //     }
  //   }
  // }
}
