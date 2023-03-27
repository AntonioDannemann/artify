class FavouritesController < ApplicationController
  def index
    @favourite_monuments = current_user.favourite_monuments

    if params[:query].present?
      sql_subquery = "monuments.name ILIKE :query OR monuments.city ILIKE :query OR monuments.country ILIKE :query"
      @favourite_monuments = @favourite_monuments.where(sql_subquery, query: "%#{params[:query]}%")
    end
    search_formats
  end

  def create
    @favourite = Favourite.new
    @favourite.user = current_user
    @favourite.monument = @monument

    if @favourite.save
      redirect_to monument_path(@monument)
    else
      render "monuments/show"
    end
  end

  def destroy
    @favourite = Favourite.find(params[:id])
    @favourite.destroy
    redirect_to @favourite.monument
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
