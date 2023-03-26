require "google/cloud/vision/v1"
require "mini_magick"
require "open-uri"

puts "Creating user"

@user = User.new(first_name: "guest", email: "#{Time.current.to_i}#{rand(999)}@guest.artify")
@user.save(validate: false)

puts "Done creating users\n\n"

Achievement.create!(title: "Let's begin", description: "Scan your first landmark", goal: 1, keyword: "all")
Achievement.create!(title: "Get Going", description: "Scan 10 landmarks", goal: 10, keyword: "all")
Achievement.create!(title: "You are a curious one", description: "Scan 20 landmarks", goal: 20, keyword: "all")
Achievement.create!(title: "Wonderluster", description: "Scan 30 landmarks", goal: 30, keyword: "all")
Achievement.create!(title: "You are an Adventurer!", description: "Scan 50 landmarks", goal: 50, keyword: "all")
Achievement.create!(title: "What a discoverer! Christopher Columbus, is that you?", description: "Scan 75 landmarks", goal: 75, keyword: "all")
Achievement.create!(title: "King of the world", description: "Scan 100 landmarks", goal: 100, keyword: "all")
Achievement.create!(title: "Mr. Worldwide", description: "Scan 150 landmarks", goal: 150, keyword: "all")
Achievement.create!(title: "Master, We don't have much more to teach you", description: "Scan 200 landmarks", goal: 200, keyword: "all")
Achievement.create!(title: "Sprinter", description: "Scan 5 landmarks in less than 24 hours", goal: 75, keyword: "all")
Achievement.create!(title: "Tourist", description: "Scan landmarks in 10 different countries", goal: 10, keyword: "all")
Achievement.create!(title: "Traveller", description: "Scan landmarks in 20 different countries", goal: 20, keyword: "all")
Achievement.create!(title: "marathonist", description: "Scan 2 landmarks in less than 24 hours that are more than 42km away from each other", goal: 2, keyword: "all")
Achievement.create!(title: "Year bucket list", description: "Scan 30 landmarks in less than a year", goal: 30, keyword: "all")
Achievement.create!(title: "All week long", description: "Scan 1 landmark per day during a week", goal: 7, keyword: "all")

Achievement.create!(title: "Athens Explorer", description: "Scan 5 landmarks from Athens", goal: 5, keyword: "Athens")
Achievement.create!(title: "Berlin Explorer", description: "Scan 5 landmarks from Berlin", goal: 5, keyword: "Bangkok")
Achievement.create!(title: "Barcelona Explorer", description: "Scan 5 landmarks from Barcelona", goal: 5, keyword: "Barcelona")
Achievement.create!(title: "Beijing Explorer", description: "Scan 5 landmarks from Beijing", goal: 5, keyword: "Beijing")
Achievement.create!(title: "Berlin Explorer", description: "Scan 5 landmarks from Berlin", goal: 5, keyword: "Berlin")
Achievement.create!(title: "Brussels Explorer", description: "Scan 5 landmarks from Brussels", goal: 5, keyword: "Brussels")
Achievement.create!(title: "Budapest Explorer", description: "Scan 5 landmarks from Budapest", goal: 5, keyword: "Budapest")
Achievement.create!(title: "Copenhagen Explorer", description: "Scan 5 landmarks from Copenhagen", goal: 5, keyword: "Copenhagen")
Achievement.create!(title: "Krakow Explorer", description: "Scan 5 landmarks from Krakow", goal: 5, keyword: "Krakow")
Achievement.create!(title: "Lisbon Explorer", description: "Scan 5 landmarks from Lisbon", goal: 5, keyword: "Lisbon")
Achievement.create!(title: "London Explorer", description: "Scan 5 landmarks from London", goal: 5, keyword: "London")
Achievement.create!(title: "Milan Explorer", description: "Scan 5 landmarks from Milan", goal: 5, keyword: "Milan")
Achievement.create!(title: "Moscow Explorer", description: "Scan 5 landmarks from Moscow", goal: 5, keyword: "Moscow")
Achievement.create!(title: "New York Explorer", description: "Scan 5 landmarks from New York", goal: 5, keyword: "New York")
Achievement.create!(title: "Paris Explorer", description: "Scan 5 landmarks from Paris", goal: 5, keyword: "Paris")
Achievement.create!(title: "Prague Explorer", description: "Scan 5 landmarks from Prague", goal: 5, keyword: "Prague")
Achievement.create!(title: "Rio de Janeiro Explorer", description: "Scan 5 landmarks from Rio de Janeiro", goal: 5, keyword: "Rio de Janeiro")
Achievement.create!(title: "Rome Explorer", description: "Scan 5 landmarks from Rome", goal: 5, keyword: "Rome")
Achievement.create!(title: "Sydney Explorer", description: "Scan 5 landmarks from Sydney", goal: 5, keyword: "Sydney")
Achievement.create!(title: "Tokyo Explorer", description: "Scan 5 landmarks from Tokyo", goal: 5, keyword: "Tokyo")
Achievement.create!(title: "Venice Explorer", description: "Scan 5 landmarks from Venice", goal: 5, keyword: "Venice")
Achievement.create!(title: "Vienna Explorer", description: "Scan 5 landmarks from Vienna", goal: 5, keyword: "Vienna")

Achievement.create!(title: "Conquering Argentina", description: "Scan 10 landmarks from Argentina", goal: 10, keyword: "Argentina")
Achievement.create!(title: "Conquering Australia", description: "Scan 10 landmarks from Australia", goal: 10, keyword: "Australia")
Achievement.create!(title: "Conquering Austria", description: "Scan 10 landmarks from Austria", goal: 10, keyword: "Austria")
Achievement.create!(title: "Conquering Belgium", description: "Scan 10 landmarks from Belgium", goal: 10, keyword: "Belgium")
Achievement.create!(title: "Conquering Bolivia", description: "Scan 10 landmarks from Bolivia", goal: 10, keyword: "Bolivia")
Achievement.create!(title: "Conquering Brazil", description: "Scan 10 landmarks from Brazil", goal: 10, keyword: "Brazil")
Achievement.create!(title: "Conquering Canada", description: "Scan 10 landmarks from Canada", goal: 10, keyword: "Canada")
Achievement.create!(title: "Conquering China", description: "Scan 10 landmarks from China", goal: 10, keyword: "China")
Achievement.create!(title: "Conquering Chile", description: "Scan 10 landmarks from Chile", goal: 10, keyword: "Chile")
Achievement.create!(title: "Conquering Colombia", description: "Scan 10 landmarks from Colombia", goal: 10, keyword: "Colombia")
Achievement.create!(title: "Conquering Czech Republic", description: "Scan 10 landmarks from Czech Republic", goal: 10, keyword: "Czech Republic")
Achievement.create!(title: "Conquering Egypt", description: "Scan 10 landmarks from Egypt", goal: 10, keyword: "Egypt")
Achievement.create!(title: "Conquering France", description: "Scan 10 landmarks from France", goal: 10, keyword: "France")
Achievement.create!(title: "Conquering Greece", description: "Scan 10 landmarks from Greece", goal: 10, keyword: "Greece")
Achievement.create!(title: "Conquering Holland", description: "Scan 10 landmarks from Holland", goal: 10, keyword: "Holland")
Achievement.create!(title: "Conquering Hungary", description: "Scan 10 landmarks from Hungary", goal: 10, keyword: "Hungary")
Achievement.create!(title: "Conquering India", description: "Scan 10 landmarks from India", goal: 10, keyword: "India")
Achievement.create!(title: "Conquering Japan", description: "Scan 10 landmarks from Japan", goal: 10, keyword: "Japan")
Achievement.create!(title: "Conquering Jordan", description: "Scan 10 landmarks from Jordan", goal: 10, keyword: "Jordan")
Achievement.create!(title: "Conquering Malaysia", description: "Scan 10 landmarks from Malaysia", goal: 10, keyword: "Malaysia")
Achievement.create!(title: "Conquering Mexico", description: "Scan 10 landmarks from Mexico", goal: 10, keyword: "Mexico")
Achievement.create!(title: "Conquering Peru", description: "Scan 10 landmarks from Peru", goal: 10, keyword: "Peru")
Achievement.create!(title: "Conquering Poland", description: "Scan 10 landmarks from Poland", goal: 10, keyword: "Poland")
Achievement.create!(title: "Conquering Portugal", description: "Scan 10 landmarks from Portugal", goal: 10, keyword: "Portugal")
Achievement.create!(title: "Conquering Russia", description: "Scan 10 landmarks from Russia", goal: 10, keyword: "Russia")
Achievement.create!(title: "Conquering Singapore", description: "Scan 10 landmarks from Singapore", goal: 10, keyword: "Singapore")
Achievement.create!(title: "Conquering Spain", description: "Scan 10 landmarks from Spain", goal: 10, keyword: "Spain")
Achievement.create!(title: "Conquering Turkey", description: "Scan 10 landmarks from Turkey", goal: 10, keyword: "Turkey")
Achievement.create!(title: "Conquering United Arab Emirates", description: "Scan 10 landmarks from United Arab Emirates", goal: 10, keyword: "United Arab Emirates")
Achievement.create!(title: "Conquering United Kingdom", description: "Scan 10 landmarks from United Kingdom", goal: 10, keyword: "United Kingdom")
Achievement.create!(title: "Conquering Vatican City", description: "Scan 10 landmarks from Vatican City", goal: 10, keyword: "Vatican City")
Achievement.create!(title: "Conquering USA", description: "Scan 10 landmarks from USA", goal: 10, keyword: "USA")

Achievement.create!(title: "Ruller of Argentina", description: "Scan 10 landmarks from Argentina", goal: 30, keyword: "Argentina")
Achievement.create!(title: "Ruller of Australia", description: "Scan 30 landmarks from Australia", goal: 30, keyword: "Australia")
Achievement.create!(title: "Ruller of Austria", description: "Scan 30 landmarks from Austria", goal: 30, keyword: "Austria")
Achievement.create!(title: "Ruller of Belgium", description: "Scan 30 landmarks from Belgium", goal: 30, keyword: "Belgium")
Achievement.create!(title: "Ruller of Bolivia", description: "Scan 30 landmarks from Bolivia", goal: 30, keyword: "Bolivia")
Achievement.create!(title: "Ruller of Brazil", description: "Scan 30 landmarks from Brazil", goal: 30, keyword: "Brazil")
Achievement.create!(title: "Ruller of Canada", description: "Scan 30 landmarks from Canada", goal: 30, keyword: "Canada")
Achievement.create!(title: "Ruller of China", description: "Scan 30 landmarks from China", goal: 30, keyword: "China")
Achievement.create!(title: "Ruller of Chile", description: "Scan 30 landmarks from Chile", goal: 30, keyword: "Chile")
Achievement.create!(title: "Ruller of Colombia", description: "Scan 30 landmarks from Colombia", goal: 30, keyword: "Colombia")
Achievement.create!(title: "Ruller of Czech Republic", description: "Scan 30 landmarks from Czech Republic", goal: 30, keyword: "Czech Republic")
Achievement.create!(title: "Ruller of Egypt", description: "Scan 30 landmarks from Egypt", goal: 30, keyword: "Egypt")
Achievement.create!(title: "Ruller of France", description: "Scan 30 landmarks from France", goal: 30, keyword: "France")
Achievement.create!(title: "Ruller of Greece", description: "Scan 30 landmarks from Greece", goal: 30, keyword: "Greece")
Achievement.create!(title: "Ruller of Holland", description: "Scan 30 landmarks from Holland", goal: 30, keyword: "Holland")
Achievement.create!(title: "Ruller of Hungary", description: "Scan 30 landmarks from Hungary", goal: 30, keyword: "Hungary")
Achievement.create!(title: "Ruller of India", description: "Scan 30 landmarks from India", goal: 30, keyword: "India")
Achievement.create!(title: "Ruller of Japan", description: "Scan 30 landmarks from Japan", goal: 30, keyword: "Japan")
Achievement.create!(title: "Ruller of Jordan", description: "Scan 30 landmarks from Jordan", goal: 30, keyword: "Jordan")
Achievement.create!(title: "Ruller of Malaysia", description: "Scan 30 landmarks from Malaysia", goal: 30, keyword: "Malaysia")
Achievement.create!(title: "Ruller of Mexico", description: "Scan 30 landmarks from Mexico", goal: 30, keyword: "Mexico")
Achievement.create!(title: "Ruller of Peru", description: "Scan 30 landmarks from Peru", goal: 30, keyword: "Peru")
Achievement.create!(title: "Ruller of Poland", description: "Scan 30 landmarks from Poland", goal: 30, keyword: "Poland")
Achievement.create!(title: "Ruller of Portugal", description: "Scan 30 landmarks from Portugal", goal: 30, keyword: "Portugal")
Achievement.create!(title: "Ruller of Russia", description: "Scan 30 landmarks from Russia", goal: 30, keyword: "Russia")
Achievement.create!(title: "Ruller of Singapore", description: "Scan 30 landmarks from Singapore", goal: 30, keyword: "Singapore")
Achievement.create!(title: "Ruller of Spain", description: "Scan 30 landmarks from Spain", goal: 30, keyword: "Spain")
Achievement.create!(title: "Ruller of Turkey", description: "Scan 30 landmarks from Turkey", goal: 30, keyword: "Turkey")
Achievement.create!(title: "Ruller of United Arab Emirates", description: "Scan 30 landmarks from United Arab Emirates", goal: 30, keyword: "United Arab Emirates")
Achievement.create!(title: "Ruller of United Kingdom", description: "Scan 30 landmarks from United Kingdom", goal: 30, keyword: "United Kingdom")
Achievement.create!(title: "Ruller of Vatican City", description: "Scan 30 landmarks from Vatican City", goal: 30, keyword: "Vatican City")
Achievement.create!(title: "Ruller of USA", description: "Scan 30 landmarks from USA", goal: 30, keyword: "USA")

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
