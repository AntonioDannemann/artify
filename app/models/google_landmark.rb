require "google/cloud/vision/v1"

class GoogleLandmark
  attr_reader :landmark, :lat, :lng, :name

  def initialize(image_url)
    @image_url = image_url
    @landmark = fetch_landmark_from_google_cloud_vision
    return unless @landmark

    @lat = @landmark.locations.first.lat_lng.latitude
    @lng = @landmark.locations.first.lat_lng.longitude
    @name = @landmark.description
  end

  private

  def fetch_landmark_from_google_cloud_vision
    client = Google::Cloud::Vision::V1::ImageAnnotator::Client.new
    response = client.landmark_detection(image: @image_url)

    # This line digs through a JSON object to return the data from the first landmark found by Google
    response.responses[0].landmark_annotations[0]
  end
end
