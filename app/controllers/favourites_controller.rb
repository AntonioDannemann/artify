class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favourites = current_user.favourites.includes(:monument)
  end

  def create
    @favourites = current_user.favorites.new(monument_id: params[:monument_id])
    authorize @favorite

    if @favourite.save
      redirect_to @favorite.monument
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
