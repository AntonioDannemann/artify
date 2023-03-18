class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home error]

  def home
    @history = History.new
    @monuments = Monument.all
    @featured_monument = featured_monument
    @nearby_monuments = @monuments.select { |mon| mon.distance_between < 5 }.sort_by { |mon| mon.distance_between }

    @ht = true if params[:ht]
    @show_footer = true

    search_form_results
  end

  def error() end

  private

  def featured_monument
    current_unix_day = Time.current.to_time.to_i.fdiv(86_400).floor

    @monuments[current_unix_day % @monuments.length]
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
