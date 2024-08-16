require 'csv'

class CSVGenerator
  def initialize(cars, file_path)
    @cars = cars
    @file_path = file_path
  end

  def generate_csv
    all_attributes = @cars.flat_map { |car| car.features.keys }.uniq

    puts "Generating with #{all_attributes.size} attributes."

    CSV.open(@file_path, 'w', encoding: 'UTF-8') do |csv|
      csv << all_attributes

      @cars.each do |car|
        row = all_attributes.map { |attr| car.features[attr] }
        csv << row
      end
    end
  end
end
