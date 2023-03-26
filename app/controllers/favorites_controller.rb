class FavoritesController < ApplicationController
  class FavoritesController < ApplicationController
    before_action :authenticate_user!

    def create
      @favorite = current_user.favorites.new(monument_id: params[:monument_id])
      authorize @favorite

      if @favorite.save
        redirect_to @favorite.monument, notice: 'Monument added to favorites'
      else
        redirect_to @favorite.monument, alert: 'Failed to add monument to favorites'
      end
    end

    def destroy
      @favorite = current_user.favorites.find(params[:id])
      authorize @favorite

      @favorite.destroy
      redirect_to @favorite.monument, notice: 'Monument removed from favorites'
    end

    private

    def authorize(record)
      return if current_user.favorites.include?(record)

      redirect_to root_path, alert: 'Access Denied'
    end
  end
end
