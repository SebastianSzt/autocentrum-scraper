require 'csv'

# The `CSVGenerator` class is responsible for generating a CSV file from a list of `Car` objects.
class CSVGenerator
  # Initializes a new `CSVGenerator` object with a list of cars and a file path.
  #
  # @param cars [Array<Car>] the list of `Car` objects to be written to the CSV file.
  # @param file_path [String] the path where the CSV file will be saved.
  def initialize(cars, file_path)
    @cars = cars
    @file_path = file_path
  end

  # Generates a CSV file with all the attributes of the cars.
  #
  # @return [void]
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
