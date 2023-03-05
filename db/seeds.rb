require "google/cloud/vision/v1"

client = Google::Cloud::Vision::V1::ImageAnnotator::Client.new
response = client.landmark_detection image: "https://www.brussels.be/sites/default/files/mannekenpis.jpg"

landmarks = response.responses.first.landmark_annotations

if landmarks.any?
  landmark = landmarks.first
  puts landmark
  puts landmark.description
  puts landmark.locations.first.lat_lng.latitude
  puts landmark.locations.first.lat_lng.longitude
else
  puts "No landmark found"
end
