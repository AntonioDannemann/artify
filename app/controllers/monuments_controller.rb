class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    if params[:search].present?
      @monuments = Monuments.global_search(params[:search])
    else
      @monuments = Monument.near([user.lat, user.lng], 5)
    end
    @monuments = policy_scope(Monument)
  end

  def show
    @monument = Monument.find(params[:id])
  end
end
