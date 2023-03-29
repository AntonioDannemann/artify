class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @user = current_user
    @monuments = Monument.all
    @monument = Monument.find_by(id: params[:id])
    @markers = [{
      type: "FeatureCollection",
      features: []
    }]

    respond
    monument_markers
  end

  def show
    @monument = Monument.find(params[:id])
    @monuments = Monument.where(city: @monument.city).where.not(id: @monument.id)

    @first_para = @monument.description.split(". ").first(2).join(". ")
    @second_para = @monument.description.split(". ")[2..].each_slice(3).map { |subarr| subarr.join(". ") }
  end

  private

  def respond
    respond_to do |format|
      format.html

      partial = "monuments/card_index"
      locals = { mon: @monument }
      format.text { render partial:, locals:, formats: [:html] }
    end
  end

  def monument_markers
    @monuments.each do |m|
      @markers.first[:features].push(
        {
          type: "Feature",
          geometry: {
            type: "Point",
            coordinates: [m.lng, m.lat]
          },
          properties: {
            id: m.id
          }
        }
      )
    end
  end
end
