# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def stable_arrangement(initial_arrangement, cast_rays: false, acceptable_seats: 4)
  arrangement = parse_arrangement(initial_arrangement)

  loop do
    new_arrangement = step(arrangement, acceptable_seats: acceptable_seats, cast_rays: cast_rays)
    break if arrangement == new_arrangement

    arrangement = new_arrangement
  end

  arrangement
end

def parse_arrangement(arrangement)
  arrangement.split("\n").map { |row| row.split("") }
end

def neighbors(arrangement, x, y, cast_rays: false)
  seat_squares = ["#", "L"]
  rays = {
    up: [0, -1],
    down: [0, 1],
    left: [-1, 0],
    right: [1, 0],
    up_right: [1, -1],
    up_left: [-1, -1],
    down_right: [1, 1],
    down_left: [-1, 1]
  }

  seen_squares = rays.values.map do |slope|
    current_square = nil
    x_pointer = x
    y_pointer = y

    loop do
      x_pointer += slope.first
      break unless x_pointer.between?(0, arrangement.first.length - 1)

      y_pointer += slope.last
      break unless y_pointer.between?(0, arrangement.length - 1)

      current_square = arrangement[y_pointer][x_pointer]
      break if seat_squares.include?(current_square) || !cast_rays
    end

    current_square
  end

  seen_squares.compact
end

def step(arrangement, cast_rays: false, acceptable_seats: 4)
  new_arrangement = Marshal.load(Marshal.dump(arrangement))
  new_arrangement.each_with_index do |row, y|
    row.each_with_index do |seat, x|
      occupied_neighbors = neighbors(arrangement, x, y, cast_rays: cast_rays)
                           .select { |neighbor| neighbor == "#" }

      if seat == "L" && occupied_neighbors.empty?
        row[x] = "#"
      elsif seat == "#" && occupied_neighbors.length >= acceptable_seats
        row[x] = "L"
      end
    end
  end
end

def count_occupied_seats(arrangement)
  arrangement.flatten.count { |seat| seat == "#" }
end

raw_test_input = test_input(raw: true)
SimpleTest.assert_equal(37, count_occupied_seats(stable_arrangement(raw_test_input)))
SimpleTest.assert_equal(26, count_occupied_seats(stable_arrangement(raw_test_input, cast_rays: true, acceptable_seats: 5)))
