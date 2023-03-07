class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @monuments = Monument.near([user.lat, user.lng], 5)
    @monuments = policy_scope(Monument)
  end

  def show
    @monument = Monument.find(params[:id])
    authorize @monument
  end
end
