require 'nokogiri'
require 'open-uri'
require 'concurrent-ruby'

require_relative 'car'

# The `CarsScraper` class is responsible for scraping car data from a list of links.
class CarsScraper
  # The maximum number of threads to be used in the thread pool.
  MAX_THREADS = 300
  # The maximum number of retries in case of an HTTP error.
  MAX_RETRIES = 3
  # The delay in seconds between retries.
  RETRY_DELAY = 5

  # @return [Array<Car>] the list of `Car` objects created from the scraped data.
  attr_reader :cars
  # @return [Array<Hash>] the list of errors that occurred during scraping.
  attr_reader :errors

  # Initializes a new `CarsScraper` object with a list of links.
  #
  # @param links [Array<String>] the list of links to be scraped.
  def initialize(links)
    @links = links
    @cars = []
    @errors = []
    @mutex = Mutex.new
    @user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
  end

  # Scrapes car data from each link in parallel using a thread pool.
  #
  # @return [void]
  def scrape_cars
    thread_pool = Concurrent::FixedThreadPool.new(MAX_THREADS)

    @links.each do |link|
      thread_pool.post do
        retries = MAX_RETRIES
        begin
          car = scrape_car_data(link)
          @mutex.synchronize { @cars << car }
        rescue OpenURI::HTTPError => e
          log_error(link, e)
          retries -= 1
          if retries > 0
            sleep(RETRY_DELAY)
            retry
          end
        rescue => e
          log_error(link, e)
          retries -= 1
          if retries > 0
            sleep(RETRY_DELAY)
            retry
          end
        end
      end
    end

    thread_pool.shutdown
    thread_pool.wait_for_termination
  end

  private

  # Scrapes the car data from a specific link and creates a `Car` object.
  #
  # @param link [String] the URL of the car specifications page.
  # @return [Car] a `Car` object with the scraped data.
  def scrape_car_data(link)
    sleep(0.03)
    doc = Nokogiri::HTML(URI.open(link, 'User-Agent' => @user_agent))

    car_attributes = {}
    car_attributes['Link'] = link
    car_attributes['Brand'] = doc.css('.breadcrumb li:nth-child(3) a span').text.strip.encode('UTF-8')
    car_attributes['Model'] = doc.css('.breadcrumb li:nth-child(4) a span').text.strip.encode('UTF-8')
    car_attributes['Engine'] = doc.css('.breadcrumb li:nth-child(5) a span').text.strip.encode('UTF-8')

    doc.css('.dt-row').each do |row|
      attribute_name = row.css('.dt-row__text__content').text.strip.encode('UTF-8')
      attribute_value = row.css('.dt-param-value').text.strip.encode('UTF-8')
      car_attributes[attribute_name] = attribute_value
    end

    Car.new(car_attributes)
  end

  # Logs an error encountered during scraping.
  #
  # @param link [String] The link associated with the error.
  # @param error [StandardError] The error object that was raised.
  # @return [void]
  def log_error(link, error)
    @mutex.synchronize do
      @errors << { link: link, error: error.message }
    end
  end
end
