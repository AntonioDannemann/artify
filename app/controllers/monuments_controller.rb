class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @user = current_user
    @monuments = policy_scope(Monument)
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
    authorize @monument
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
