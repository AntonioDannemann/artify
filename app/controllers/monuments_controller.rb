class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @monuments = policy_scope(Monument).near([user.lat, user.lng], 5)
  end

  def show
    @monument = Monument.find(params[:id])
    authorize @monument
  end
end
