class Car
  attr_reader :features

  def initialize(attributes = {})
    @features = {}
    attributes.each do |key, value|
      @features[key] = value
    end
  end

  def to_s
    @features.map { |key, value| "#{key}: #{value}" }.join(', ')
  end
end
