class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favourites = current_user.favourites.includes(:monument)
  end

  def create
    @monument = Monument.find(params[:monument_id])
    @favourite = current_user.favourites.build(monument: @monument)

    if @favourite.save
      redirect_to @monument, notice: "Added to favourites!"
    else
      redirect_to @monument, alert: "Unable to add to favourites."
    end
  end

  def destroy
    @favourite = current_user.favourites.find_by(monument_id: params[:monument_id])
    @favourite.destroy

    redirect_to @favourite.monument, notice: "Removed from favourites."
  end
end
