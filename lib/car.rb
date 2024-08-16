# The `Car` class represents a single car with a set of technical features.
# Each car is initialized with a hash mapping features to their values.
class Car
  # @return [Hash] a dictionary of car features where keys are feature names and values are their corresponding values.
  attr_reader :features

  # Initializes a new `Car` object.
  #
  # @param attributes [Hash] a hash where keys are car feature names and values are their corresponding values.
  #   If no hash is provided, an empty `Car` object is created.
  def initialize(attributes = {})
    @features = {}
    attributes.each do |key, value|
      @features[key] = value
    end
  end

  # Returns a string representation of the `Car` object.
  #
  # @return [String] a string representation of the car features, where each feature is displayed on a new line in the format "name: value".
  def to_s
    @features.map { |key, value| "#{key}: #{value}" }.join("\n")
  end
end
