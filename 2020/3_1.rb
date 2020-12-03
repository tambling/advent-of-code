# frozen_string_literal: true

require_relative "../aoc_helper"

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

test_fixture = <<~FOREST
  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#
FOREST

assert_equal(trees_encountered(inputs(test_fixture)), 7)

slopes = [
 [1, 1],
 [3, 1],
 [5, 1],
 [7, 1],
 [1, 2]
]

test_result = slopes.map do |slope|
  trees_encountered(inputs(test_fixture), across: slope.first, down: slope.last)
end.reduce(&:*)

assert_equal(test_result, 336)

result = slopes.map do |slope|
  trees_encountered(inputs, across: slope.first, down: slope.last)
end.reduce(&:*)

present_answer(result)
