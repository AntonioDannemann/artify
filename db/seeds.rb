require "google/cloud/vision/v1"
require "mini_magick"
require "open-uri"

puts "Creating user"

@user = User.new(first_name: "guest", email: "#{Time.current.to_i}#{rand(999)}@guest.artify")
@user.save(validate: false)

puts "Done creating users\n\n"

Achievement.create!(title: "Let's begin", description: "Scan your first landmark", goal: 1, keyword: "all")
Achievement.create!(title: "Get Going", description: "Scan 10 landmarks", goal: 10, keyword: "all")
Achievement.create!(title: "Paris Explorer", description: "Scan 5 landmarks from Paris", goal: 5, keyword: "Paris")

arc_de_triomphe = "https://cdn.britannica.com/66/80466-050-2E125F5C/Arc-de-Triomphe-Paris-France.jpg"
atomium = "https://upload.wikimedia.org/wikipedia/commons/c/cf/Brussels_-_Atomium_2022.jpg"
big_ben = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg/640px-Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg"
colosseum = "https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Colosseo_2020.jpg/1200px-Colosseo_2020.jpg"
eiffel_tower = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Tour_Eiffel_Wikimedia_Commons_%28cropped%29.jpg/640px-Tour_Eiffel_Wikimedia_Commons_%28cropped%29.jpg"
invalides = "https://cdn.britannica.com/37/155337-050-E035C14E/Dome-des-Invalides-Paris-Jules-Hardouin-Mansart-1706.jpg"
manneken_pis = "https://upload.wikimedia.org/wikipedia/commons/c/c4/Bruxelles_Manneken_Pis_cropped.jpg"
mount_rushmore = "https://www.history.com/.image/ar_4:3%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTU3ODc5MDg2NDMyNjU5MTY3/morning-light-on-4.jpg"
pantheon = "https://lp-cms-production.imgix.net/2019-06/88ea89abfafda42bb41ea785744af5af-pantheon.jpg"
pena_palace = "https://tourscanner.com/blog/wp-content/uploads/2019/05/Pena-Palace-tickets-1.png"
statue_of_liberty = "https://www.history.com/.image/ar_4:3%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTY1MTc1MTk3ODI0MDAxNjA5/topic-statue-of-liberty-gettyimages-960610006-promo.jpg"

monument_images = [
  arc_de_triomphe,
  atomium,
  big_ben,
  colosseum,
  eiffel_tower,
  invalides,
  manneken_pis,
  pantheon,
  pena_palace,
  statue_of_liberty,
  mount_rushmore
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
  @landmark_names = [@landmark_name, @landmark_name.downcase, @landmark_name.split.map(&:capitalize).join(" ")]

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

  if history.monument
    method_start = Time.current
    attach_photo_to_model(history, image_url, history.monument.name)
    puts "#{Time.current - method_start}s to complete attach_photo_to_model(history)"
  end

  history
end

def find_monument_by_landmark
  method_start = Time.current
  monument = Monument.find_by(name: @landmark_name.split.map(&:capitalize).join(" "))
  puts "#{Time.current - method_start}s to complete find_monument_by_landmark"

  monument
end

def create_monument
  data = nil
  @landmark_names.each { |name| break if (data = fetch_data_from_wikipedia(name)) }

  unless data
    puts "No wikipedia page found for https://en.wikipedia.org/wiki/#{@landmark_name.tr(' ', '_')}"
    return nil
  end

  monument = Monument.new(data[:params])
  method_start = Time.current
  attach_photo_to_model(monument, data[:photo_url], monument.name)
  puts "#{Time.current - method_start}s to complete attach_photo_to_model(monument)"

  method_start = Time.current
  monument.fetch_geocoder
  puts "#{Time.current - method_start}s to complete fetch_geocoder_for_monument_update"

  method_start = Time.current
  if monument.save
    puts "#{Time.current - method_start}s to save monument"
    monument.add_achievements
    return monument
  end

  nil
end

def fetch_data_from_wikipedia(name)
  method_start = Time.current
  page = Wikipedia.find(name)
  return nil unless page.extlinks

  params = { params: {
               name: name.split.map(&:capitalize).join(" "),
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
  if photo.size > 50_000_000
    photo = compress_photo(photo, 10)
  elsif photo.size > 26_214_400
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

start = Time.current
puts "Creating monuments and histories"

monument_images.each do |image_url|
  monument_start = Time.current
  history = build_history_from_photo(image_url)

  next puts "Process failed after #{Time.current - monument_start}s\n\n" if history.nil?

  method_start = Time.current
  if history.save
    puts "#{Time.current - method_start}s to save history"

    Achievement.all.each do |ach|
      MonumentAchievement.create!(achievement: ach, monument: history.monument)
    end
    puts "#{history.monument.name} created in #{Time.current - monument_start}s\n\n" if history
  else
    puts "Process failed after #{Time.current - monument_start}s\n\n"
  end
end

puts "Done creating monuments and histories\n\n"

puts "Seed completed in #{Time.current - start}s"
