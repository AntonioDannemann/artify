require "mini_magick"

class PhotoCompressor
  attr_reader :compressed_photo

  def initialize(photo)
    @photo = photo
    @compressed_photo = processed_photo(@photo)
  end

  private

  def processed_photo(photo)
    image = resized_photo(photo)

    if image.size > 5_242_880
      image = compress_image(image, 30)
    elsif image.size > 2_621_440
      image = compress_image(image, 50)
    elsif image.size > 1_048_576
      image = compress_image(image, 80)
    end

    StringIO.open(image.to_blob)
  end

  def resized_photo(photo)
    image = MiniMagick::Image.new(photo.path)
    image.resize "1920x1920"
  end

  def compress_image(image, quality)
    image.quality quality
  end
end
