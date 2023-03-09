class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @monuments = policy_scope(Monument).near([48.858093, 2.294694], 5)
    @user = User.find(144)

    @markers = @monuments.geocoded.map do |monument|
      {
        lat: monument.lat,
        lng: monument.lng
      }
    end
  end

  def show
    @monument = Monument.find(params[:id])
    authorize @monument
  end
end
