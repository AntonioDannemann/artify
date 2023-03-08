require "open-uri"
require "google/cloud/vision/v1"

puts "Destroying all monuments"
Monument.destroy_all

puts "Destroying all users"
User.destroy_all

puts "Destroying all histories"
History.destroy_all

puts "Done destroying"

puts "creating a new client"

client = Google::Cloud::Vision::V1::ImageAnnotator::Client.new

puts "done with client"

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

puts "creating users"

User.create!(
  first_name: "guest",
  last_name: "Ramos",
  email: "louisramosdev@gmail.com",
  password: "password"
)

user = User.create!(
  first_name: "Rutger",
  last_name: "Schoone",
  email: "rcschoone@gmail.com",
  password: "password",
  lat: 48.858093,
  lng: 2.294694
)

image_url = URI.open("https://cdn.britannica.com/54/75854-050-E27E66C0/Eiffel-Tower-Paris.jpg")
response = client.landmark_detection(image: image_url)
landmark = response.responses.first.landmark_annotations.first
landmark_lat = landmark.locations.first.lat_lng.latitude
landmark_lng = landmark.locations.first.lat_lng.longitude
landmark_name = landmark.description

page = Wikipedia.find(landmark_name)
data = {
  params: {
    name: landmark_name,
    lat: landmark_lat,
    lng: landmark_lng,
    description: page.summary,
    website_url: search_page_raw_data_for_website_url(page)
  },
  photo_url: page.main_image_url
}
monument = Monument.new(data[:params])
photo = URI.parse(data[:photo_url]).open
monument.photo.attach(io: photo, filename: "#{monument.name}.png", content_type: "image/png")
geocoder = Geocoder.search("#{monument.lat},#{monument.lng}").first
monument.city = geocoder.city
monument.country = geocoder.country
monument.country_code = geocoder.country_code.upcase
monument.save

history = History.new
history.photo.attach(io: image_url, filename: "#{monument.name}.png", content_type: "image/png")
history.user = user
history.monument = monument
history.save

puts user.first_name
puts history.monument.name
puts monument.city
