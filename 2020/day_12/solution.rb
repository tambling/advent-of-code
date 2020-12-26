# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

INSTRUCTION_REGEX = /(?<direction>[NSEWLRF])(?<distance>\d+)/
def manhattan_distance(instructions)
  heading = "E"
  y = 0
  x = 0

  instructions.each do |instruction|
    parsed_instruction = INSTRUCTION_REGEX.match(instruction)
    direction = parsed_instruction[:direction]
    distance = parsed_instruction[:distance].to_i

    if %w[L R].include? direction
      heading = calculate_heading(heading, direction, distance)
    elsif direction == "F"
      y, x = calculate_new_position(y, x, heading, distance)
    else
      y, x = calculate_new_position(y, x, direction, distance)

    end
  end

  y.abs + x.abs
end

def calculate_heading(current_heading, direction, distance)
  directions = %w[N E S W]
  current_index = directions.index(current_heading)
  offset = distance / 90
  new_index = if direction == "R"
                (current_index + offset) % 4
              else
                (current_index - offset) % 4
              end

  directions[new_index]
end

def calculate_new_position(y, x, direction, distance)
  case direction
  when "N"
    [y + distance, x]
  when "E"
    [y, x + distance]
  when "S"
    [y - distance, x]
  when "W"
    [y, x - distance]
  end
end

def manhattan_distance_with_waypoints(instructions)
  y = 0
  x = 0

  waypoint_x = 10
  waypoint_y = 1

  instructions.each do |instruction|
    parsed_instruction = INSTRUCTION_REGEX.match(instruction)
    direction = parsed_instruction[:direction]
    distance = parsed_instruction[:distance].to_i

    if %w[L R].include?(direction)
      waypoint_y, waypoint_x = rotate_waypoint(waypoint_y, waypoint_x, direction, distance)
    elsif direction == "F"
      y, x = move(y, x, waypoint_y, waypoint_x, distance)
    else
      waypoint_y, waypoint_x = calculate_new_position(waypoint_y, waypoint_x, direction, distance)
    end
  end

  y.abs + x.abs
end

def move(y, x, waypoint_y, waypoint_x, times)
  times.times do
    y += waypoint_y
    x += waypoint_x
  end

  [y, x]
end

def rotate_waypoint(y, x, direction, distance)
  return [-y, -x] if distance == 180

  if (direction == "L" && distance == 90) || (direction == "R" && distance == 270)
    p "turning 1 unit counterclockwise"
    return [x, -y]
  else
    p "turning 1 unit clockwise"
    return [-x, y]
  end
end

SimpleTest.assert_equal(25, manhattan_distance(test_input))
SimpleTest.assert_equal(286, manhattan_distance_with_waypoints(test_input))
present_answer(manhattan_distance_with_waypoints(input))
