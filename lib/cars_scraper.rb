require 'nokogiri'
require 'open-uri'
require 'concurrent-ruby'

require_relative 'car'

class CarsScraper
  MAX_THREADS = 300

  attr_reader :cars

  def initialize(links)
    @links = links
    @cars = []
    @mutex = Mutex.new
  end

  def scrape_cars
    thread_pool = Concurrent::FixedThreadPool.new(MAX_THREADS)

    @links.each do |link|
      thread_pool.post do
        car = scrape_car_data(link)
        @mutex.synchronize { @cars << car }
      end
    end

    thread_pool.shutdown
    thread_pool.wait_for_termination
  end

  def scrape_car_data(link)
    doc = Nokogiri::HTML(URI.open(link))

    car_attributes = {}

    car_attributes['Link'] = link
    car_attributes['Marka'] = doc.css('.breadcrumb li:nth-child(3) a span').text.strip.encode('UTF-8')
    car_attributes['Model'] = doc.css('.breadcrumb li:nth-child(4) a span').text.strip.encode('UTF-8')
    car_attributes['Silnik'] = doc.css('.breadcrumb li:nth-child(5) a span').text.strip.encode('UTF-8')
    
    doc.css('.dt-row').each do |row|
      attribute_name = row.css('.dt-row__text__content').text.strip.encode('UTF-8')
      attribute_value = row.css('.dt-param-value').text.strip.encode('UTF-8')
      car_attributes[attribute_name] = attribute_value
    end

    Car.new(car_attributes)
  end
end
