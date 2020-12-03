require_relative './aoc_helper'

class Line
  attr_reader :points
  def initialize(instructions)
    @instructions = instructions
    @points = []
    evaluate_points
  end

  private

  def evaluate_points
    cursor = { x: 0, y: 0 }
    @instructions.each do |instruction|
      direction = instruction[0]
      distance = instruction[1..-1].to_i
      distance.times do
        case direction
        when 'U'
          cursor[:y] += 1
        when 'D'
          cursor[:y] -= 1
        when 'L'
          cursor[:x] -= 1
        when 'R'
          cursor[:x] += 1
        end
        @points.push([cursor[:x], cursor[:y]])
      end
    end
    points.uniq!
  end
end

def manhattan_intersection(instruction_sets)
  point_sets = instruction_sets
    .map { |set| set.split(",") }
    .map { |instructions| Line.new(instructions) }
    .map(&:points)

  intersections = point_sets.reduce(&:&)

  intersections
    .map { |intersection| intersection[0].abs + intersection[1].abs }
    .min
end

first_fixture = [
  "R75,D30,R83,U83,L12,D49,R71,U7,L72",
  "U62,R66,U55,R34,D71,R55,D58,R83"
]
assert_equal manhattan_intersection(first_fixture), 159
second_fixture = [
  'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51',
  'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7'
]

assert_equal manhattan_intersection(second_fixture), 135

distance = manhattan_intersection(inputs)
present_answer(distance)
