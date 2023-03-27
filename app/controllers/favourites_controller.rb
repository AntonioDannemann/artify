class FavouritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favourite, only: [:destroy]

  def index
    @favourites = policy_scope(current_user.favourites)
  end

  def create
    @monument = Monument.find(params[:monument_id])
    @favourite = current_user.favourites.build(monument: @monument)
    authorize @favourite

    if @favourite.save
      redirect_to @favourite.monument
    else
      redirect_to @monument
    end
  end

  def destroy
    authorize @favourite
    @favourite.destroy
    redirect_to @favourite.monument
  end

  private

  def set_favourite
    @favourite = current_user.favourites.find_by(monument_id: params[:monument_id])
  end
end
