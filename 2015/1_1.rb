# frozen_string_literal: true

require_relative "../aoc_helper"

def floor_count(input)
  floor = 0

  input.split("").each_with_index do |char, i|
    floor += 1 if char == "("
    floor -= 1 if char == ")"

    p i + 1 if floor == -1
  end

  floor
end

present_answer(floor_count(inputs.first))
