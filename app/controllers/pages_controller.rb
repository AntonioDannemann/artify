class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home error]

  def home
    @history = History.new
    @monuments = Monument.all
    @monument = @monuments.sample
    @ht = true if params[:ht]
  end

  def error() end
end
