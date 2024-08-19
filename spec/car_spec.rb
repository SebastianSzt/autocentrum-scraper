require 'rspec'
require_relative '../lib/car'

RSpec.describe Car do
  describe '#initialize' do
    it 'creates a car with given attributes' do
      attributes = { 'Brand' => 'Toyota', 'Model' => 'Corolla', 'Engine' => '1.8L' }
      car = Car.new(attributes)

      expect(car.features['Brand']).to eq('Toyota')
      expect(car.features['Model']).to eq('Corolla')
      expect(car.features['Engine']).to eq('1.8L')
    end

    it 'creates an empty car when no attributes are given' do
      car = Car.new

      expect(car.features).to be_empty
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the car features' do
      attributes = { 'Brand' => 'Toyota', 'Model' => 'Corolla', 'Engine' => '1.8L' }
      car = Car.new(attributes)

      expected_string = "Brand: Toyota\nModel: Corolla\nEngine: 1.8L"
      expect(car.to_s).to eq(expected_string)
    end
  end
end
