class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @user = current_user
    @monuments = policy_scope(Monument)
    @nearby_monuments = @monuments.select { |mon| mon.distance_between < 5 }.sort_by(&:distance_between)

    @markers = @monuments.map { |monument| { lat: monument.lat, lng: monument.lng, photo: monument.photo.url } }
  end

  def show
    @monument = Monument.find(params[:id])
    authorize @monument
  end
end
