# autocentrum-scraper

This project is a Ruby-based web scraper designed to collect car specifications from a autocentrum site. The scraped data is then stored in a CSV file for easy analysis.

## Overview

The Car Data Scraper fetches car specification URLs from a sitemap, scrapes the technical data from these pages, and saves the results in a CSV file. The process is optimized with multithreading to handle a large number of requests efficiently.

## Requirements

- Ruby 3.3 or higher
- `nokogiri` gem
- `concurrent-ruby` gem

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/SebastianSzt/autocentrum-scraper.git
    cd web-scraper
    ```

2. Install the required gems:
    ```sh
    bundle install
    ```
    
## Usage

1. Modify the main.rb script if needed to adjust the number of links to scrape or output file paths.

2. Run the scraper:
    ```sh
    ruby main.rb
    ```

3. The scraped data will be saved in a `cars.csv` file in the project directory.