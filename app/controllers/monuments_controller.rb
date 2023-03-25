class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @user = current_user
    @monuments = policy_scope(Monument)
    @nearby_monuments = @monuments.select { |mon| mon.distance_between < 5 }.sort_by(&:distance_between)

    @markers = @monuments.map { |monument| { lat: monument.lat, lng: monument.lng } }
  end

  def show
    @monument = Monument.find(params[:id])
    @monuments = Monument.where(city: @monument.city).where.not(id: @monument.id)
    @first_para = @monument.description.split(". ").first(2).join(". ")
    @second_para = @monument.description.split(". ")[2..].each_slice(3).map { |subarr| subarr.join(". ") }
    authorize @monument
  end
end
