# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def prepare_joltages(joltages)
  joltages.push(0)
  joltages.push(joltages.max + 3)
  joltages.sort
end

def joltage_jumps(jumbled_joltages)
  joltages = prepare_joltages(jumbled_joltages)

  jumps = Hash.new { 0 }

  (1...joltages.length).each do |i|
    current = joltages[i]
    previous = joltages[i - 1]

    jumps[current - previous] += 1
  end

  jumps
end

SimpleTest.assert_equal({1 => 22, 3 => 10}, joltage_jumps(test_input.map(&:to_i)))

def possible_paths_through(jumbled_joltages)
  joltages = prepare_joltages(jumbled_joltages)

  pearls = [[]]

  (0...(joltages.length - 1)).each do |i|
    pearls.last.push joltages[i]

    pearls.push([]) if (joltages[i + 1] - joltages[i]) == 3
  end

  pearls.last.push(joltages.last)

  pearls
    .map { |pearl| (pearl.length - 2).positive? ? pearl.length - 2 : 0 }
    .map { |superfluous_count| 2**superfluous_count }
    .map { |count| count - (count / 2**3) }
    .reduce(&:*)
end

SimpleTest.assert_equal(19_208, possible_paths_through(test_input.map(&:to_i)))
