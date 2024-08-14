require 'nokogiri'
require 'open-uri'

class LinksScraper
  def initialize(url)
    @url = url
    @links = []
  end

  def scrape_links
    doc = Nokogiri::XML(URI.open(@url))
    namespace = {'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9'}

    doc.xpath('//xmlns:url/xmlns:loc', namespace).each do |link|
      @links << link.text
    end

    filter_links
  end

  attr_reader :filtered_links

  private

  def filter_links
    @filtered_links = @links.reject do |link|
      @links.any? { |l| l != link && l.start_with?(link) }
    end
  end
end
