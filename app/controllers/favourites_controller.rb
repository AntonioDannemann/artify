class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favourites = current_user.favourites.where(user_id: current_user.id)
  end

  def create
    @monument = Monument.find(params[:monument_id])
    @favourite = Favourite.new(user: current_user, monument: @monument)
    authorize @favourite

    if @favourite.save
      redirect_to @favourite.monument
    else
      redirect_to @monument
    end
  end

  def destroy
    @favourite = current_user.favourites.find_by(monument_id: params[:monument_id])
    @favourite.destroy

    redirect_to @favourite.monument
  end
end
