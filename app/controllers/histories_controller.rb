require "google/cloud/vision/v1"
require "mini_magick"
require 'open-uri'

class HistoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show create]

  def index
    @histories = policy_scope(History)
  end

  def show
    @history = History.find(params[:id])
    authorize @history
  end

  def create
    @photo = params[:history][:photo]
    @user = current_user || User.find_by(first_name: "guest")
    @history = build_history_from_photo(@photo.path)

    authorize @history

    if @history.save
      redirect_to history_path(@history)
    else
      redirect_to error_path
    end
  end

  private

  def build_history_from_photo(image_url)
    landmark = fetch_landmark_from_google_cloud_vision(image_url)

    # We check whether a @landmark has been found and if not we return a new instance of History
    # The reason is that back in the #create action we authorize the value of @history
    # Pundit can't authorize an instance with a value of nil
    # So we pass an empty History, it passes the authorization but not the validation and the #save fails
    return History.new unless landmark

    @landmark_lat = landmark.locations.first.lat_lng.latitude
    @landmark_lng = landmark.locations.first.lat_lng.longitude
    @landmark_name = landmark.description
    @history_lat = params[:history][:lat].to_f
    @history_lng = params[:history][:lng].to_f

    if Geocoder::Calculations.distance_between([@history_lat, @history_lng], [@landmark_lat, @landmark_lng]) < 5
      new_history
    else
      redirect_to error_path
    end
  end

  def fetch_landmark_from_google_cloud_vision(image_url)
    client = Google::Cloud::Vision::V1::ImageAnnotator::Client.new
    response = client.landmark_detection(image: image_url)

    # This line digs through a JSON object to return the data from the first landmark found by Google
    response.responses.first.landmark_annotations.first
  end

  def new_history
    history = History.new(photo: @photo)
    history.user = @user
    history.lat = @history_lat
    history.lng = @history_lng
    # We first check in the database if there is a monument that corresponds to our current landmark
    # If not we create one
    history.monument = find_monument_by_landmark || create_monument

    history
  end

  def find_monument_by_landmark
    Monument.find_by(name: @landmark_name, lat: @landmark_lat, lng: @landmark_lng)
  end

  def create_monument
    data = fetch_data_from_wikipedia
    return nil unless data

    monument = Monument.new(data[:params])
    monument.attach_photo(data[:photo_url]) if data[:photo_url]
    monument.fetch_geocoder

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
    # This is gonna be one of those "Trust me, Bro" moment
    # This method is basically digging through an enormous Hash of the whole page's data
    # An example of such Has can be found in root/resources/wikipedia_raw_data.rb
    # We first need to search through our Hash for a JSON of the page's whole content
    content_json = page.raw_data.dig("query", "pages").values.first["revisions"].first["*"]

    # Then we dig through that JSON object until we find the website_url from the Infobox
    # You can see where this is exactly located in the root/resources/wikipedia_raw_data.rb file
    # Open that file and search (CTRL + F) for "BOOKMARK"
    website_url_regexp =
      %r/
      # This checks for a line that starts with website
      [ ]*\|[ ]*website[ ]*=[^|]*\|
      # This starts a matching group for the website URL and checks for the presence of https-https and www
      ((?:https?:\/\/)?(?:www\.)?
      # This is the website name and domain. Ex - Artify.click
      [-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}
      # This checks for any params And we close the matching group
      \b(?:[-a-zA-Z0-9()@:%_+.~#?&\/=]*))
      /x

    website_url = content_json.match(website_url_regexp)&.[](1)

    # Finally most url fetched from Wikipedia don't come with https:// or http:// in front of link
    # Because of that they can't be used as href for <a> tags
    # So we verify that the url has http or https and if not, we add it
    # We also verify that the link is working
    verify_url(website_url)
  end

  def verify_url(url)
    return nil unless url

    url = url.match?(/https|http/) ? url : "https://#{url}"
    uri = URI.parse(url)
    return nil unless uri.is_a?(URI::HTTP) && !uri.host.nil?

    url
  end
end
