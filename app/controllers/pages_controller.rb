class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home error]

  def home
    @history = History.new

    @monuments = Monument.all
    @monument = @monuments.sample

    @ht = true if params[:ht]

    search_monuments
  end

  def error() end

  private

  def search_monuments
    @searched_monuments = []
    if params[:search] && params[:search] != ""
      @searched_monuments = @monuments.where("name ILIKE ?", "%#{params[:search]}%")
    end

    respond_to do |format|
      format.html
      format.text { render partial: "pages/components/search_list", locals: { monuments: @searched_monuments }, formats: [:html] }
    end
  end
end
