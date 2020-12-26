# frozen_string_literal: true

require_relative "../../helper"

def spiral_distance(index)
  ring = determine_ring(index)
  low, high = figure_out_which_side_youre_on(ring, index)
  midpoint =  find_the_midpoint(high, low)
  distance_from_midpoint = find_distance_from_midpoint(midpoint, index)

  distance_from_midpoint + ring
end

def determine_ring(number)
  (1..Float::INFINITY).step(2).each do |root|
    return root.to_i / 2 if root**2 >= number
  end
end

def figure_out_which_side_youre_on(ring, index)
  side_length = (ring * 2 + 1)
  ultimate_corner = side_length**2

  nearest_corner = ultimate_corner
  while nearest_corner > index
    nearest_corner -= (side_length - 1)
  end

  return [nearest_corner, (nearest_corner + side_length - 1)]
end

def find_the_midpoint(low, high)
  high - (high - low) / 2
end

def find_distance_from_midpoint(index, midpoint)
  (index - midpoint).abs
end

SimpleTest.assert_equal(0, spiral_distance(1))
SimpleTest.assert_equal(3, spiral_distance(12))
SimpleTest.assert_equal(2, spiral_distance(23))
SimpleTest.assert_equal(31, spiral_distance(1024))

present_answer(spiral_distance(368_078))
