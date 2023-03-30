require "open-uri"

class WikipediaData
  attr_reader :photo_url, :params

  def initialize(name, lat, lng)
    @name = name
    @lat = lat
    @lng = lng

    @page = Wikipedia.find(@name)
    return unless valid?

    @photo = URI.parse(@page.main_image_url).open
    @photo = nil unless @photo.content_type.match?(/image\/(avif|jpeg|png)/)
    @params = wikipedia_data_params
  end

  private

  def valid?
    @page.extlinks
  end

  def wikipedia_data_params
    {
      name: @name.split.map(&:capitalize).join(" "),
      lat: @lat,
      lng: @lng,
      description: @page.summary,
      website_url: search_page_raw_data_for_website_url(@page)
    }
  end

  def search_page_raw_data_for_website_url(page)
    # This is gonna be one of those "Trust me, Bro" moment
    # This method is basically digging through an enormous Hash of the whole page's data
    # An example of such Has can be found in root/resources/wikipedia_raw_data.rb
    # We first need to search through our Hash for a JSON of the page's whole content
    content_json = page.raw_data.dig("query", "pages").values.first["revisions"].first["*"]

    # Then we dig through that JSON object until we find the website_url from the Infobox
    # You can see where this is exactly located in the root/resources/wikipedia_raw_data.rb file
    # Open that file and search (CTRL + F) for "BOOKMARK"
    website_url_regexp = %r/
      # This checks for a line that starts with website
      [ ]*\|[ ]*website[ ]*=[^|]*\|
      # This starts a matching group for the website URL and checks for the presence of https-https and www
      ((?:https?:\/\/)?(?:www\.)?
      # This is the website name and domain. Ex - Artify.click
      [-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}
      # This checks for any params And we close the matching group
      \b(?:[-a-zA-Z0-9()@:%_+.~#?&\/=]*))
      /x

    website_url = content_json.match(website_url_regexp)&.[](1)
    return nil unless website_url

    # Finally most url fetched from Wikipedia don't come with https:// or http:// in front of link
    # Because of that they can't be used as href for <a> tags
    # So we verify that the url has http or https and if not, we add it
    # We also verify that the link is working
    verify_url(website_url)
  end

  def verify_url(url)
    url = url.match?(/https|http/) ? url : "https://#{url}"
    uri = URI.parse(url)
    return nil unless uri.is_a?(URI::HTTP) && !uri.host.nil?

    url
  end
end
