# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def fuel_required(mass, fuel_has_mass: false)
  fuel_mass = mass / 3 - 2

  return 0 if fuel_mass.negative?

  if fuel_has_mass
    fuel_mass + fuel_required(fuel_mass, fuel_has_mass: true)
  else
    fuel_mass
  end
end

SimpleTest.assert_equal(2, fuel_required(12))
SimpleTest.assert_equal(2, fuel_required(14))
SimpleTest.assert_equal(654, fuel_required(1969))
SimpleTest.assert_equal(33_583, fuel_required(100_756))

first_answer = input.map do |input_line|
  fuel_required(input_line.to_i)
end.sum

SimpleTest.assert_equal(3_324_332, first_answer)

SimpleTest.assert_equal(2, fuel_required(14, fuel_has_mass: true))
SimpleTest.assert_equal(966, fuel_required(1969, fuel_has_mass: true))
SimpleTest.assert_equal(50_346, fuel_required(100_756, fuel_has_mass: true))

second_answer = input.map do |input_line|
  fuel_required(input_line.to_i, fuel_has_mass: true)
end.sum

SimpleTest.assert_equal(4_983_626, second_answer)
