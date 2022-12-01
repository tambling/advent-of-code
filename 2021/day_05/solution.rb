# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def solution(lines)
  line_regex = /(?<x1>\d+),(?<y1>\d+) -> (?<x2>\d+),(?<y2>\d+)/
  field = {}

  parsed_lines = lines.map { |line| line.match(line_regex) }

  parsed_lines.each do |parsed_line|
    x1 = parsed_line[:x1].to_i
    x2 = parsed_line[:x2].to_i
    y1 = parsed_line[:y1].to_i
    y2 = parsed_line[:y2].to_i

    straight  = x1 == x2 || y1 == y2

    if straight

      ([y1, y2].min..[y1, y2].max).each do |y|
        ([x1, x2].min..[x1, x2].max).each do |x|
          field[y] ||= Hash.new { 0 }
          field[y][x] += 1
        end
      end
    else
      x_magnitude = x2 - x1
      y_magnitude = y2 - y1

      x_neg = x_magnitude.negative?
      y_neg = y_magnitude.negative?

      (0..y_magnitude.abs).each do |offset|
          y = y_neg ? y1 - offset : y1 + offset
          x = x_neg ? x1 - offset : x1 + offset

          field[y] ||= Hash.new { 0 }
          field[y][x] += 1
        end
    end
  end

  puts print_field(field)
  field.values.map { |row| row.values.select { |cell| cell > 1 }.length }.sum
end

def print_field(field)
  string = (0..9).map do |y|
    (0..9).map do |x|
      if !field[y] || field[y][x] == 0
        "."
      else
        field[y][x]
      end
    end.join
  end.join("\n")
end


SimpleTest.assert_equal(12, solution(test_input))
present_answer(solution(input))
