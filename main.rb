require_relative 'lib/links_scraper'
require 'fileutils'
require 'time'

def fetch_links(links_url, output_file)
  puts "Checking if links are cached in #{output_file}."
  if File.exist?(output_file) && (Time.now - File.mtime(output_file)) < 7 * 24 * 60 * 60
    puts 'Found cached links.'
    links = File.readlines(output_file).map(&:chomp)
  else
    puts "No cached links found. Scraping links from #{links_url}"
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

links_url = 'https://www.autocentrum.pl/sitemap/daneTechniczne.xml'
output_links_file = 'links.txt'

puts "Fetching links..."
links = fetch_links(links_url, output_links_file)

puts "Number of links: #{links.size}"

puts "First 4 links:"
links.first(4).each { |link| puts link }