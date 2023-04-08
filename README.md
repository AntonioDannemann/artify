<div align="center"><img src="/app/assets/images/eiffel-logo.png" height="200"></div>

## About
This app was created as part of our LeWagon bootcamp.
It serves as a mobile oriented website and PWA to scan pictures of landmarks taken by users, recognise the content of the picture and return actual informations about said landmark. It does so by using both Google Cloud Vision's api, specifically it's landmark recognition feature, to scan images and Wikipedia's api to procedurally generate any missing landmark from our database. 

**Feel free to have a look at [Artify](www.artify.click/)**

## Features
**Landmark recognition from a picture**<br><br>
<img src="/app/assets/images/README/readme_gif_1.gif" height="500">

<br>
<br>

**App gamification through achievement system**<br><br>
<img src="/app/assets/images/README/readme_gif_2.gif" height="500">

<br>
<br>

**Geolocation and display of surrounding landmarks**<br><br>
<img src="/app/assets/images/README/readme_gif_3.gif" height="500">

## installation
<p>
  <!-- version -->
  <img src='https://badgen.net/badge/Ruby/v3.1.2/red' />
  <img src='https://badgen.net/badge/Rails/v7.0.4.2/red' />
</p>

```
git clone git@github.com:wJoenn/artify.git
cd artify
rails db:setup
bundle
yarn
dev
```
