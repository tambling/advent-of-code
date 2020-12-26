# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def trees_encountered(input, across: 3, down: 1)
  trees = 0
  column = 0

  (0...input.length).step(down) do |i|
    row = input[i]
    trees += 1 if row[column] == "#"
    column += across
    column %= row.length
  end

  trees
end

SimpleTest.assert_equal(trees_encountered(test_input), 7)

slopes = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2]
]

test_slope_multiple = slopes.map do |slope|
  trees_encountered(test_input, across: slope.first, down: slope.last)
end.reduce(&:*)

SimpleTest.assert_equal(test_slope_multiple, 336)
