class FavouritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favourite, only: [:destroy]

  def index
    @favourites = current_user.favourites
    @user = current_user
    @favourites = @favourites.where(user: @user).order(updated_at: :desc)

    if params[:query].present?
      sql_subquery = "monuments.name ILIKE :query OR monuments.location ILIKE :query"
      @favourites = @favourites.joins(:monument).where(sql_subquery, query: "%#{params[:query]}%")
    end

    search_formats
  end

  def create
    @monument = Monument.find(params[:monument_id])
    @favourite = current_user.favourites.build(monument: @monument)

    if @favourite.save
      redirect_to @favourite.monument
    else
      redirect_to @monument
    end
  end

  def destroy
    @favourite.destroy
    redirect_to @favourite.monument
  end

  private

  def set_favourite
    @favourite = current_user.favourites.find_by(monument_id: params[:monument_id])
  end

  def search_formats
    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "favourites/components/list", locals: { histories: @histories }, formats: [:html] }
    end
  end
end
