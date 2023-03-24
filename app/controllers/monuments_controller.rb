class MonumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @user = current_user
    @monuments = policy_scope(Monument)
    @nearby_monuments = @monuments.select { |mon| mon.distance_between < 5 }.sort_by(&:distance_between)

    @markers = [{
      type: "FeatureCollection",
      features: []
    }]

    @monuments.each do |m|
      @markers.first[:features].push(
        {
          type: "Feature",
          geometry: {
            type: "Point",
            coordinates: [m.lng, m.lat]
          },
          properties: {
            name: m.name,
            photo: "https://res.cloudinary.com/dr1wktgbk/image/upload/q_10/development/#{m.photo.key}",
            key: m.photo.key,
            id: m.id,
            city: m.city,
            desc: m.description.split.first(20).join(" ")
          }
        }
      )
    end
  end

  def show
    @monument = Monument.find(params[:id])
    authorize @monument
  end
end
