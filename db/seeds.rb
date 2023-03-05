require "google/cloud/vision/v1"

puts "Destroying all monuments"
Monument.destroy_all

Monument.create!(
  name: "Manneken Pis",
  lat: 50.844993,
  lng: 4.349989,
  description: "a",
  completion_date: Time.zone.today,
  style: "a"
)

Monument.create!(
  name: "Atomium",
  lat: 50.894919,
  lng: 4.341466,
  description: "a",
  completion_date: Time.zone.today,
  style: "a"
)

client = Google::Cloud::Vision::V1::ImageAnnotator::Client.new
response = client.landmark_detection image: "https://upload.wikimedia.org/wikipedia/commons/c/cf/Brussels_-_Atomium_2022.jpg"

landmarks = response.responses.first.landmark_annotations

if landmarks.any?
  landmark = landmarks.first
  data = {
    description: landmark.description,
    lat: landmark.locations.first.lat_lng.latitude,
    lng: landmark.locations.first.lat_lng.longitude
  }
  p data

  history = History.new(data)
  monuments = Monument.near([history.lat, history.lng], 10)
  p monuments || "No monuments found near [#{history.lat}, #{history.lng}]"

  monument = monuments.find_by(name: history.description)
  puts monument || "No monument found"
else
  puts "No landmark found"
end
