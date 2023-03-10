class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @user = User.find(144)
    @monuments = policy_scope(Monument)

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
