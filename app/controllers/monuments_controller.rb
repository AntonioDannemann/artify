class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @user = current_user
    # @monuments = policy_scope(Monument)
    @monuments = policy_scope(Monument).near([48.8584, 2.2945], 5)

    @markers = @monuments.map { |monument| { lat: monument.lat, lng: monument.lng } }
  end

  def show
    @monument = Monument.find(params[:id])
    authorize @monument
  end
end
