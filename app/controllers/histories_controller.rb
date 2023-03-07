require 'open-uri'

class HistoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show create]

  def show
    @history = History.find(params[:id])
    authorize @history
  end

  def create
    @photo = params[:history][:photo]
    @user = current_user || User.find_by(first_name: "guest")
    @history = find_monument_by_image_url(@photo.path)

    authorize @history
    if @history.save
      redirect_to history_path(@history)
    else
      redirect_to error_path
    end
  end

  private

  def find_monument_by_image_url(image_url)
    landmark = fetch_landmark_from_google_cloud_vision(image_url)
    return History.new unless landmark

    new_history(landmark)
  end

  def fetch_landmark_from_google_cloud_vision(image_url)
    require "google/cloud/vision/v1"

    client = Google::Cloud::Vision::V1::ImageAnnotator::Client.new
    response = client.landmark_detection(image: image_url)

    response.responses.first.landmark_annotations.first
  end

  def new_history(landmark)
    history = History.new(history_params(landmark))
    history.user = @user
    history.monument = find_monument_by_history(history)

    history
  end

  def history_params(landmark)
    {
      description: landmark.description,
      lat: landmark.locations.first.lat_lng.latitude,
      lng: landmark.locations.first.lat_lng.longitude,
      photo: @photo
    }
  end

  def find_monument_by_history(history)
    monuments = Monument.near([history.lat, history.lng], 1)
    monument = monuments.find_by(name: history.description)
    return monument if monument

    create_monument(history)
  end

  def create_monument(history)
    data = fetch_data_from_wikipedia(history)
    return nil unless data

    monument = Monument.new(data[:params])
    attach_photo_to_monument(monument, data[:photo_url])
    fetch_geocoder_for_monument_update(monument)

    return monument if monument.sav

    nil
  end

  def fetch_data_from_wikipedia(history)
    page = Wikipedia.find(history.description)
    return nil unless page.content

    { params: {
        name: history.description,
        lat: history.lat,
        lng: history.lng,
        description: page.summary,
        website_url: search_page_raw_data_for_website_url(page)
      },
      photo_url: page.main_image_url }
  end

  def search_page_raw_data_for_website_url(page)
    hash = {}

    # This is gonna be one of those "Trust me, Bro" moment
    revisions = page.raw_data["query"]["pages"].first[1]["revisions"]
    return nil unless revisions

    revisions.first["*"].split("\n\n").first.split("}}\n{{").last
             .split("\n").map(&:strip).select { _1[0] == "|" }
             .map { _1[1..].split("=").map(&:strip) }
             .map { _1.length == 1 ? _1.push("") : _1 }
             .each { hash[_1[0].downcase] = _1[1].gsub(/\[|\]|{|}/, "").split("|").last }

    verify_url(hash["website"])
  end

  def verify_url(url)
    return nil unless url

    url.match?(/https|http/) ? url : "https://#{url}"
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
end
