# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def solution(instructions, use_aim: false)
  horizontal = 0
  vertical = 0
  aim = 0

  instructions.each do |instruction|
    direction, magnitude = instruction.split(" ")

    case direction
    when "forward"
      horizontal += magnitude.to_i
      vertical += magnitude.to_i * aim
    when "down"
      if use_aim
        aim += magnitude.to_i
      else
      vertical += magnitude.to_i
      end
    when "up"
      if use_aim
        aim -= magnitude.to_i
      else
      vertical -= magnitude.to_i
      end
    end
  end

  horizontal * vertical
end

SimpleTest.assert_equal(150, solution(test_input))
SimpleTest.assert_equal(900, solution(test_input, use_aim: true))

present_answer(solution(input))
present_answer(solution(input, use_aim: true))
