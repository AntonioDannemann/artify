class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @monuments = Monument.near([user.lat, user.lng], 5)
  end

  def show
    @monument = Monument.find(params[:id])
  end
end
