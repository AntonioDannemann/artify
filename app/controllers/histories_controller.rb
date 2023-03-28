require 'open-uri'

class HistoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show create]

  def index
    @user = current_user
    @histories = @user.histories.order(updated_at: :desc)

    if params[:query].present?
      sql_subquery = "monuments.name ILIKE :query OR monuments.location ILIKE :query"
      @histories = @histories.joins(:monument).where(sql_subquery, query: "%#{params[:query]}%")
    end

    search_formats
  end

  def show
    @history = History.find(params[:id])
    return redirect_to root_path unless @history.user == (current_user || guest_user)

    @monument = @history.monument
    @monuments = Monument.where(city: @monument.city).where.not(id: @monument.id)

    @first_para = @monument.description.split(". ").first(2).join(". ")
    @second_para = @monument.description.split(". ")[2..].each_slice(3).map { |subarr| subarr.join(". ") }

    @new_achievements = current_user&.new_achievements
  end

  def create
    @photo = PhotoCompressor.new(params[:history][:photo]).compressed_photo
    @user = current_user || guest_user
    @history = build_history_from_photo(@photo)

    if @history.new_record? && @history.save
      current_user&.update_achievements(@history.monument.achievements)
      return redirect_to history_path(@history)
    elsif @history.save then return redirect_to history_path(@history)
    end

    render "pages/error"
  end

  private

  def build_history_from_photo(image_url)
    google_landmark = GoogleLandmark.new(image_url)

    # We check whether a @landmark has been found and if not we return a new instance of History
    # The reason is that back in the #create action we authorize the value of @history
    # Pundit can't authorize an instance with a value of nil
    # So we pass an empty History, it passes the authorization but not the validation and the #save fails
    unless google_landmark.landmark
      @error = "no landmark found on google"
      return History.new
    end

    initialize_landmark_instance_variable(google_landmark)

    find_history_by_landmark || new_history
  end

  def initialize_landmark_instance_variable(google_landmark)
    @landmark_lat = google_landmark.lat
    @landmark_lng = google_landmark.lng
    @raw_landmark_name = google_landmark.name
    @landmark_name = @raw_landmark_name.split.map(&:capitalize).join(" ")
    @landmark_names = [@raw_landmark_name, @raw_landmark_name.downcase, @landmark_name]
  end

  def find_history_by_landmark
    history = History.joins(:monument).find_by(user: @user, monument: { name: @landmark_name })
    return nil unless history

    history.photo.purge_later
    history.photo.attach(io: @photo, filename: "#{@landmark_name}#{@user.id}.jpeg", content_type: "image/jpeg")

    history
  end

  def new_history
    history = History.new
    history.user = @user
    history.photo.attach(io: @photo, filename: "#{@landmark_name}#{@user.id}.jpeg", content_type: "image/jpeg")

    # We first check in the database if there is a monument that corresponds to our current landmark
    # If not we create one
    history.monument = find_monument_by_landmark || create_monument

    history
  end

  def find_monument_by_landmark
    Monument.find_by(name: @landmark_name)
  end

  def create_monument
    data = @landmark_names.find do |name|
      data = WikipediaData.new(name, @landmark_lat, @landmark_lng)
      break data if data.params
    end

    unless data
      @error = "no data found on wikipedia"
      return nil
    end

    Monument.find_by(description: data.params[:description]) || new_monument(data)
  end

  def new_monument(data)
    monument = Monument.new(data.params)
    monument.fetch_geocoder
    if data.photo_url
      monument.photo.attach(
        io: PhotoCompressor.new(URI.parse(data.photo_url).open).compressed_photo,
        filename: "#{monument.name}.jpeg",
        content_type: "image/jpeg"
      )
    end

    return unless monument.save

    monument.add_achievements
    monument
  end

  def search_formats
    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "histories/components/list", locals: { histories: @histories }, formats: [:html] }
    end
  end
end
