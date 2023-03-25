class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @user = current_user
    @monuments = policy_scope(Monument)
    @lat = 48.858461
    @lng = 2.294351
    @nearby_monuments = @monuments.select { |mon| mon.distance_between(@lat, @lng) < 5 }
                                  .sort_by { |mon| mon.distance_between(@lat, @lng) }

    @markers = @monuments.map { |monument| { lat: monument.lat, lng: monument.lng } }
  end

  def show
    @monument = Monument.find(params[:id])

    authorize @monument

    @monuments = Monument.where(city: @monument.city).where.not(id: @monument.id)
    @first_para = @monument.description.split(". ").first(2).join(". ")
    @second_para = @monument.description.split(". ")[2..].each_slice(3).map { |subarr| subarr.join(". ") }
  end
end
