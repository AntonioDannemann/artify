class FavouritesController < ApplicationController
  def index
    @favourite_monuments = current_user.favourites.order(created_at: :desc).map(&:monument)

    if params[:query].present?
      sql_subquery = "monuments.name ILIKE :query OR monuments.city ILIKE :query OR monuments.country ILIKE :query"
      @favourite_monuments = @favourite_monuments.where(sql_subquery, query: "%#{params[:query]}%")
    end
    search_formats
  end

  def create
    @monument = Monument.find(params[:monument_id])
    @favourite = Favourite.new
    @favourite.monument = @monument
    @favourite.user = current_user

    @favourite.save
    redirect_back_or_to monument_path(@monument)
  end

  def destroy
    @favourite = Favourite.find(params[:id])
    @favourite.destroy
    redirect_back_or_to monument_path(@favourite.monument)
  end

  private

  def search_formats
    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text do
        render partial: "favourites/components/list", locals: { favourite_monuments: @favourite_monuments },
               formats: [:html]
      end
    end
  end
end
