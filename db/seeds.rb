require "google/cloud/vision/v1"
require "mini_magick"
require "open-uri"

puts "Destroying all monuments"
Monument.destroy_all

puts "Destroying all users"
User.destroy_all

puts "Destroying all histories"
History.destroy_all

puts "Done destroying\n\n"

puts "Creating users"

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

puts "Done creating users\n\n"

arc_de_triomphe = "https://cdn.britannica.com/66/80466-050-2E125F5C/Arc-de-Triomphe-Paris-France.jpg"
big_ben = "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0d/63/f8/bb/big-ben.jpg?w=1200&h=1200&s=1&pcx=1033&pcy=310&pchk=v1_bf93e1170e1f1f8d4cea"
dam_square = "https://www.patrimonia.nl/wp-content/uploads/2018/04/PM_FINALPICS_001-9-lr.jpg"
duomo = "https://www.yesmilano.it/sites/default/files/styles/testata_full/public/luogo/copertina/62/511/Duomo_PIX_1280x560.jpg?itok=gsd4zBxj"
eiffel_tower = "https://cdn.britannica.com/54/75854-050-E27E66C0/Eiffel-Tower-Paris.jpg"
invalides = "https://cdn.britannica.com/37/155337-050-E035C14E/Dome-des-Invalides-Paris-Jules-Hardouin-Mansart-1706.jpg"
pantheon = "https://cdn.britannica.com/13/123413-050-6572DF6D/Pantheon-Paris.jpg"
sagrada_familia = "https://cdn.britannica.com/15/194815-050-08B5E7D1/Nativity-facade-Sagrada-Familia-cathedral-Barcelona-Spain.jpg"
statue_of_liberty = "https://www.history.com/.image/ar_4:3%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTY1MTc1MTk3ODI0MDAxNjA5/topic-statue-of-liberty-gettyimages-960610006-promo.jpg"

monument_images = [
  arc_de_triomphe,
  big_ben,
  dam_square,
  duomo,
  eiffel_tower,
  invalides,
  pantheon,
  sagrada_familia,
  statue_of_liberty
]

def build_history_from_photo(image_url)
  landmark = fetch_landmark_from_google_cloud_vision(image_url)
  unless landmark
    puts "No landmark found from #{image_url}"
    return nil
  end

  @landmark_lat = landmark.locations.first.lat_lng.latitude
  @landmark_lng = landmark.locations.first.lat_lng.longitude
  @landmark_name = landmark.description

  new_history(image_url)
end

def fetch_landmark_from_google_cloud_vision(image_url)
  method_start = Time.current
  client = Google::Cloud::Vision::V1::ImageAnnotator::Client.new
  response = client.landmark_detection(image: image_url)

  landmark = response.responses.first.landmark_annotations.first
  puts "#{Time.current - method_start}s to complete fetch_landmark_from_google_cloud_vision"

  landmark
end

def new_history(image_url)
  history = History.new
  history.user = @user
  history.monument = find_monument_by_landmark || create_monument

  method_start = Time.current
  attach_photo_to_model(history, image_url, history.monument.name)
  puts "#{Time.current - method_start}s to complete attach_photo_to_model(history)"

  history
end

def find_monument_by_landmark
  method_start = Time.current
  monument = Monument.find_by(name: @landmark_name, lat: @landmark_lat, lng: @landmark_lng)
  puts "#{Time.current - method_start}s to complete find_monument_by_landmark"

  monument
end

def create_monument
  data = fetch_data_from_wikipedia
  return nil unless data

  monument = Monument.new(data[:params])
  method_start = Time.current
  attach_photo_to_model(monument, data[:photo_url], monument.name)
  puts "#{Time.current - method_start}s to complete attach_photo_to_model(monument)"

  method_start = Time.current
  fetch_geocoder_for_monument_update(monument)
  puts "#{Time.current - method_start}s to complete fetch_geocoder_for_monument_update"

  method_start = Time.current
  if monument.save
    puts "#{Time.current - method_start}s to save monument"
    return monument
  end

  nil
end

def fetch_data_from_wikipedia
  method_start = Time.current
  page = Wikipedia.find(@landmark_name)
  return nil unless page.coordinates

  params = { params: {
               name: @landmark_name,
               lat: @landmark_lat,
               lng: @landmark_lng,
               description: page.summary,
               website_url: search_page_raw_data_for_website_url(page)
             },
             photo_url: page.main_image_url }
  puts "#{Time.current - method_start}s to complete fetch_data_from_wikipedia"

  params
end

def search_page_raw_data_for_website_url(page)
  method_start = Time.current
  content_json = page.raw_data.dig("query", "pages").values.first["revisions"].first["*"]

  website_url_regexp =
    %r/
    [ ]*\|[ ]*website[ ]*=[^|]*\|
    ((?:https?:\/\/)?(?:www\.)?
    [-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}
    \b(?:[-a-zA-Z0-9()@:%_+.~#?&\/=]*))
    /x

  website_url = content_json.match(website_url_regexp)&.[](1)
  puts "#{Time.current - method_start}s to complete search_page_raw_data_for_website_url"

  method_start = Time.current
  url = verify_url(website_url)
  puts "#{Time.current - method_start}s to complete verify_url"

  url
end

def verify_url(url)
  return nil unless url

  url = url.match?(/https|http/) ? url : "https://#{url}"
  uri = URI.parse(url)
  return nil unless uri.is_a?(URI::HTTP) && !uri.host.nil?

  url
end

def attach_photo_to_model(model, photo_url, filename)
  photo = URI.parse(photo_url).open
  if photo.size > 26_214_400
    photo = compress_photo(photo, 40)
  elsif photo.size > 5_242_880
    photo = compress_photo(photo, 80)
  end

  model.photo.attach(io: photo, filename:, content_type: "image/png")
end

def compress_photo(photo, quality)
  method_start = Time.current
  image = MiniMagick::Image.new(photo.path)
  image.combine_options { |o| o.quality quality }
  photo = StringIO.open(image.to_blob)
  puts "#{Time.current - method_start}s to complete compress_photo"

  photo
end

def fetch_geocoder_for_monument_update(monument)
  geocoder = Geocoder.search("#{monument.lat},#{monument.lng}").first
  monument.city = geocoder.city
  monument.country = geocoder.country
  monument.country_code = geocoder.country_code.upcase
end

start = Time.current
puts "Creating monuments and histories"

monument_images.each do |image_url|
  monument_start = Time.current
  history = build_history_from_photo(image_url)

  method_start = Time.current
  history.save!
  puts "#{Time.current - method_start}s to save history"

  puts "#{history.monument.name} created in #{Time.current - monument_start}s\n\n" if history
end

puts "Done creating monuments and histories\n\n"

puts "Seed completed in #{Time.current - start}s"
