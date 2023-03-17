class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home error]

  def home
    @history = History.new

    @monuments = Monument.all
    @monument = @monuments.sample

    search_monuments
    respond_to do |format|
      format.html
      format.text do
        render({
                 partial: "pages/components/search_list",
                 locals: { monuments: @searched_monuments },
                 formats: [:html]
               })
      end
    end
  end

  def error() end

  private

  def search_monuments
    @searched_monuments = []
    return unless params[:search] && params[:search] != ""

    sql_query = "name ILIKE :query OR city ILIKE :query OR country ILIKE :query"
    @searched_monuments = @monuments.where(sql_query, query: "%#{params[:search]}%")
  end
end
