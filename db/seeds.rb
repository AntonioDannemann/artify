require "open-uri"
require "google/cloud/vision/v1"

puts "Destroying all monuments"
Monument.destroy_all

puts "Destroying all users"
User.destroy_all

puts "Destroying all histories"
History.destroy_all

puts "Done destroying"

puts "creating users"

User.create!(
  first_name: "guest",
  last_name: "Ramos",
  email: "louisramosdev@gmail.com",
  password: "password"
)

@user = User.create!(
  first_name: "Rutger",
  last_name: "Schoone",
  email: "rcschoone@gmail.com",
  password: "password",
  lat: 48.858093,
  lng: 2.294694
)

puts "users created"

monument_images = [
  # Eiffel tower
  "https://cdn.britannica.com/54/75854-050-E27E66C0/Eiffel-Tower-Paris.jpg",
  # Invalides
  "https://cdn.britannica.com/37/155337-050-E035C14E/Dome-des-Invalides-Paris-Jules-Hardouin-Mansart-1706.jpg",
  # Pantheon (paris)
  "https://cdn.britannica.com/13/123413-050-6572DF6D/Pantheon-Paris.jpg",
  # Arc de triomph
  "https://cdn.britannica.com/66/80466-050-2E125F5C/Arc-de-Triomphe-Paris-France.jpg",
  # Duomo
  "https://www.yesmilano.it/sites/default/files/styles/testata_full/public/luogo/copertina/62/511/Duomo_PIX_1280x560.jpg?itok=gsd4zBxj",
  # Dam square
  "https://www.patrimonia.nl/wp-content/uploads/2018/04/PM_FINALPICS_001-9-lr.jpg",
  # Big ben
  "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0d/63/f8/bb/big-ben.jpg?w=1200&h=1200&s=1&pcx=1033&pcy=310&pchk=v1_bf93e1170e1f1f8d4cea",
  # Sagrada Familia
  "https://cdn.britannica.com/15/194815-050-08B5E7D1/Nativity-facade-Sagrada-Familia-cathedral-Barcelona-Spain.jpg",
  # Statue of Liberty
  "https://www.history.com/.image/ar_4:3%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTY1MTc1MTk3ODI0MDAxNjA5/topic-statue-of-liberty-gettyimages-960610006-promo.jpg"
]

def build_history_from_photo(image_url)
  landmark = fetch_landmark_from_google_cloud_vision(image_url)
  return nil unless landmark

  @landmark_lat = landmark.locations.first.lat_lng.latitude
  @landmark_lng = landmark.locations.first.lat_lng.longitude
  @landmark_name = landmark.description

  new_history(image_url)
end

def fetch_landmark_from_google_cloud_vision(image_url)
  client = Google::Cloud::Vision::V1::ImageAnnotator::Client.new
  response = client.landmark_detection(image: image_url)

  response.responses.first.landmark_annotations.first
end

def new_history(image_url)
  history = History.new
  history.user = @user
  history.monument = find_monument_by_landmark
  photo = URI.parse(image_url).open
  history.photo.attach(io: photo, filename: history.monument.name, content_type: "image/png")
  history
end

def find_monument_by_landmark
  monuments = Monument.near([@landmark_lat, @landmark_lng], 1)
  monument = monuments.find_by(name: @landmark_name)
  return monument if monument

  create_monument
end

def create_monument
  data = fetch_data_from_wikipedia
  return nil unless data

  monument = Monument.new(data[:params])
  attach_photo_to_monument(monument, data[:photo_url])
  fetch_geocoder_for_monument_update(monument)

  return monument if monument.save

  nil
end

def fetch_data_from_wikipedia
  page = Wikipedia.find(@landmark_name)
  return nil unless page.coordinates

  { params: {
      name: @landmark_name,
      lat: @landmark_lat,
      lng: @landmark_lng,
      description: page.summary,
      website_url: search_page_raw_data_for_website_url(page)
    },
    photo_url: page.main_image_url }
end

def search_page_raw_data_for_website_url(page)
  content_json = page.raw_data.dig("query", "pages").values.first["revisions"].first["*"]

  website_url_regexp =
    %r/
    [ ]*\|[ ]*website[ ]*=[^|]*\|
    ((?:https?:\/\/)?(?:www\.)?
    [-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}
    \b(?:[-a-zA-Z0-9()@:%_+.~#?&\/=]*))
    /x

  website_url = content_json.lines.find { |line| line.match?(website_url_regexp) }&.match(website_url_regexp)&.[](1)
  verify_url(website_url)
end

def verify_url(url)
  return nil unless url

  url = url.match?(/https|http/) ? url : "https://#{url}"
  uri = URI.parse(url)
  return nil unless uri.is_a?(URI::HTTP) && !uri.host.nil?

  url
end

def attach_photo_to_monument(monument, photo_url)
  photo = URI.parse(photo_url).open
  monument.photo.attach(io: photo, filename: "#{monument.name}.png", content_type: "image/png")
end

def fetch_geocoder_for_monument_update(monument)
  geocoder = Geocoder.search("#{monument.lat},#{monument.lng}").first
  monument.city = geocoder.city
  monument.country = geocoder.country
  monument.country_code = geocoder.country_code.upcase
end

monument_images.each do |image_url|
  @history = build_history_from_photo(image_url)

  puts Monument.last.name
end
