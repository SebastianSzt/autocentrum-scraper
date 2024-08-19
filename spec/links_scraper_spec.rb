require 'rspec'
require 'webmock/rspec'
require_relative '../lib/links_scraper'

RSpec.describe LinksScraper do
  before do
    stub_request(:get, 'https://www.example.com/sitemap.xml')
      .to_return(body: <<-XML
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
          <url>
            <loc>https://www.example.com/car1</loc>
          </url>
          <url>
            <loc>https://www.example.com/car2</loc>
          </url>
        </urlset>
      XML
      )
  end

  describe '#scrape_links' do
    it 'scrapes and filters links from the sitemap' do
      scraper = LinksScraper.new('https://www.example.com/sitemap.xml')
      scraper.scrape_links

      expect(scraper.filtered_links).to contain_exactly(
        'https://www.example.com/car1',
        'https://www.example.com/car2'
      )
    end
  end
end
