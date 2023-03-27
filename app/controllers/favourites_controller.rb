class FavouritesController < ApplicationController
  before_action :set_favourite, only: [:destroy]

  def index
    @favourite_monuments = current_user.favourites.includes(:monument).order(updated_at: :desc)

    if params[:query].present?
      sql_subquery = "monuments.name ILIKE :query OR monuments.city ILIKE :query OR monuments.country_code ILIKE :query"
      @favourite_monuments = @favourite_monuments.joins(:monument).where(sql_subquery, query: "%#{params[:query]}%")
    end
    search_formats
  end

  def create
    @monument = Monument.find(params[:monument_id])
    @favourite = current_user.favourites.new(monument: @monument)

    if @favourite.save
      redirect_to @favourite.monument
    else
      redirect_to root_path
    end
  end

  def destroy
    @favourite.destroy
    redirect_to @favourite.monument
  end

  private

  def set_favourite
    @favourite = current_user.favourites.find(params[:id])
  end

  def search_formats
    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "favourites/components/list", locals: { histories: @histories }, formats: [:html] }
    end
  end
end
