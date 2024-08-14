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

    puts 'Scraping car attributes... ' + link

    #TODO: Implement scraping of car attributes

    Car.new(car_attributes)
  end
end
