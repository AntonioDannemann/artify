class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def index
    if params[:search].present?
      @monuments = Monuments.global_search(params[:search])
    else
      @monuments = Monument.near([user.lat, user.lng], 5)
    end
  end
end
