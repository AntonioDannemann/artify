class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home error]

  def home
    @history = History.new
    @monuments = Monument.order(:name)
    @featured_monument = Monument.featured
    @user_lat = params[:lat]
    @user_lng = params[:lng]
    nearby_results

    @ht = true if params[:ht]
    @show_footer = true

    search_form_results
  end

  def error() end

  private

  def nearby_results
    @nearby_monuments = []
    return unless @user_lat && @user_lng

    @nearby_monuments = @monuments.select { |mon| mon.distance_between(@user_lat, @user_lng) < 5 }
                                  .sort_by { |mon| mon.distance_between(@user_lat, @user_lng) }

    respond_to do |format|
      format.html

      partial = "shared/monuments_scroller"
      locals = { monuments: @nearby_monuments, lat: @user_lat, lng: @user_lng }
      format.text { render partial:, locals:, formats: [:html] }
    end
  end

  def search_form_results
    @searched_monuments = []
    return unless params[:search] && params[:search] != ""

    sql_query = "name ILIKE :query OR city ILIKE :query OR country ILIKE :query"
    @searched_monuments = @monuments.where(sql_query, query: "%#{params[:search]}%")

    respond_to do |format|
      format.html

      partial = "pages/components/search_list"
      format.text { render partial:, locals: { monuments: @searched_monuments }, formats: [:html] }
    end
  end
end
