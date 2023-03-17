class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home error]

  def home
    @history = History.new
    @featured_monument = featured_monument

    @ht = true if params[:ht]

    search_form_results
  end

  def error() end

  private

  def featured_monument
    monuments = Monument.all
    current_unix_day = Time.current.to_time.to_i.fdiv(86_400).floor

    monuments[current_unix_day % monuments.length]
  end

  def search_form_results
    @searched_monuments = []
    if params[:search] && params[:search] != ""
      @searched_monuments = @monuments.where("name ILIKE ?", "%#{params[:search]}%")
    end

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
end
