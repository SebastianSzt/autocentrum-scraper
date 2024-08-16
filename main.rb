require 'fileutils'
require 'time'
require 'logger'

require_relative 'lib/links_scraper'
require_relative 'lib/cars_scraper'
require_relative 'lib/csv_generator'

logger = Logger.new('error.log')
logger.level = Logger::DEBUG

# Fetches links from a sitemap or uses cached links if available and not expired.
#
# @param links_url [String] the URL of the sitemap XML file.
# @param output_file [String] the path to the file where cached links are stored.
# @return [Array<String>] the list of links to be scraped.
def fetch_links(links_url, output_file)
  puts "Checking if links are cached in #{output_file}."
  if File.exist?(output_file) && (Time.now - File.mtime(output_file)) < 7 * 24 * 60 * 60
    puts 'Found cached links.'
    links = File.readlines(output_file).map(&:chomp)
  else
    puts "No unexpired cached links found. Scraping links from #{links_url}"
    links_scraper = LinksScraper.new(links_url)
    links_scraper.scrape_links
    links = links_scraper.filtered_links

    File.open(output_file, 'w') do |file|
      links.each { |link| file.puts(link) }
    end

    puts "Links saved to #{output_file}."
  end
  links
end

begin
  links_url = 'https://www.autocentrum.pl/sitemap/daneTechniczne.xml'
  output_links_file = 'links.txt'

  puts 'Fetching links...'
  links = fetch_links(links_url, output_links_file)

  puts "\nNumber of links: #{links.size}"

  puts "\nScraping cars..."
  cars_scraper = CarsScraper.new(links.first(14))
  cars_scraper.scrape_cars
  cars = cars_scraper.cars

  # Uncomment the lines below to print each car's details to the console.
  # cars.each do |car|
  #   puts car.to_s
  #   puts "-------------------"
  # end
  
  puts "\nGenerating CSV file..."
  csv_file_path = 'cars.csv'
  csv_generator = CSVGenerator.new(cars, csv_file_path)
  csv_generator.generate_csv

  puts "\nSuccessfully scraped and generated cars file: #{csv_file_path}"
rescue IOError => e
  logger.error("IOError occurred: #{e.message}")
  logger.error(e.backtrace.join("\n"))
rescue ArgumentError => e
  logger.error("ArgumentError occurred: #{e.message}")
  logger.error(e.backtrace.join("\n"))
rescue RuntimeError => e
  logger.error("RuntimeError occurred: #{e.message}")
  logger.error(e.backtrace.join("\n"))
rescue StandardError => e
  logger.error("An error occurred: #{e.message}")
  logger.error(e.backtrace.join("\n"))
rescue Exception => e
  logger.fatal("An unexpected error occurred: #{e.message}")
  logger.fatal(e.backtrace.join("\n"))
end
