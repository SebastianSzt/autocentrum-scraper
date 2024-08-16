require 'nokogiri'
require 'open-uri'

# The `LinksScraper` class is responsible for scraping car specification links from a sitemap XML file.
class LinksScraper
  # Initializes a new `LinksScraper` object with a URL.
  #
  # @param url [String] the URL of the sitemap XML file.
  def initialize(url)
    @url = url
    @links = []
  end

  # Scrapes the links from the XML sitemap and filters them.
  #
  # @return [void]
  def scrape_links
    doc = Nokogiri::XML(URI.open(@url))
    namespace = {'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9'}

    doc.xpath('//xmlns:url/xmlns:loc', namespace).each do |link|
      @links << link.text
    end

    filter_links
  end

  # @return [Array<String>] the filtered list of links.
  attr_reader :filtered_links

  private

  # Filters out links that are prefixes of other links.
  #
  # @return [void]
  def filter_links
    @filtered_links = @links.reject do |link|
      @links.any? { |l| l != link && l.start_with?(link) }
    end
  end
end
