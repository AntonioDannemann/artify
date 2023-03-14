class Monument < ApplicationRecord
  has_many :histories, dependent: :destroy
  has_one_attached :photo

  reverse_geocoded_by :lat, :lng, address: :location
  after_validation :reverse_geocode

  validates :name, :description, :lat, :lng, :city, :country, :country_code, presence: true
  validates :lat, :lng, numericality: { only_float: true }

  def self.with_missing_photo
    Monument.all.reject { |monument| monument.photo.attached? }
  end

  def attach_photo(photo_url)
    photo = URI.parse(photo_url).open
    if photo.size > 26_214_400
      photo = compress_photo(photo, 40)
    elsif photo.size > 5_242_880
      photo = compress_photo(photo, 80)
    end

    self.photo.attach(io: photo, filename: "#{name}.jpeg", content_type: "image/jpeg")
  end

  def fetch_geocoder
    geocoder = Geocoder.search("#{lat},#{lng}").first
    self.city = geocoder.city
    self.country = geocoder.country
    self.country_code = geocoder.country_code.upcase
  end

  private

  def compress_photo(photo, quality)
    image = MiniMagick::Image.new(photo.path)
    image.combine_options { |option| option.quality quality }
    StringIO.open(image.to_blob)
  end
end
