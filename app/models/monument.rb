require "open-uri"

class Monument < ApplicationRecord
  has_many :histories, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :monument_achievements, dependent: :destroy
  has_many :achievements, through: :monument_achievements
  has_one_attached :photo

  reverse_geocoded_by :lat, :lng, address: :location
  after_validation :reverse_geocode

  validates :name, :description, :lat, :lng, :city, :country, :country_code, presence: true
  validates :lat, :lng, numericality: { only_float: true }

  def self.featured
    monument = Monument.find_by(featured_date: Date.current)
    return monument if monument

    current_unix_day = Time.current.to_time.to_i.fdiv(86_400).floor
    monuments = Monument.all
    monument = monuments.select { |mon| mon.photo.attached? }[current_unix_day % monuments.length]
    monument.update(featured_date: Date.current)

    monument
  end

  def self.without_photo
    Monument.all.reject { |monument| monument.photo.attached? }
  end

  def add_achievements
    Achievement.where(keyword: ["all", city, country]).find_each do |achievement|
      MonumentAchievement.create(achievement:, monument: self)
    end
  end

  def attach_url(photo_url)
    photo = PhotoCompressor.new(URI.parse(photo_url).open)
    self.photo.purge_later
    self.photo.attach(io: photo.compressed_photo, filename: "#{name}.jpeg", content_type: "image/jpeg")
  end

  def distance_between(user_lat, user_lng)
    distance = Geocoder::Calculations.distance_between([user_lat, user_lng], [lat, lng])
    distance = distance > 5 ? distance.round : distance.round(1)

    distance == distance.to_i ? distance.to_i : distance
  end

  def fetch_geocoder
    geocoder = Geocoder.search("#{lat},#{lng}").first
    self.city = geocoder.city || geocoder.suburb || geocoder.county
    self.country = geocoder.country
    self.country_code = geocoder.country_code.upcase
  end
end
