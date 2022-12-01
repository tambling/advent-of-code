# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def solution(fish, steps)
  fish_list = fish.split(",").map(&:to_i)
  fish_tallies = fish_list.tally

  steps.times do
    step_tally(fish_tallies)
  end

  fish_tallies.values.compact.sum
end

def step_tally(tallies)
  new_fish = 0
  reset_fish = 0

  0.upto(7) do |i|
    new_fish = reset_fish = tallies[i] || 0 if i.zero?

    tallies[i] = tallies[i + 1]
  end
  tallies[6] ||= 0
  tallies[6] += reset_fish
  tallies[8] = new_fish

  tallies
end

SimpleTest.assert_equal(5934, solution(test_input.first, 80))
present_answer(solution(input.first, 256))
