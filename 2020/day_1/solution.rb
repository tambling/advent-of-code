# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def multiple_when_sum_equals(inputs, target, permutation_size = 2)
  inputs.permutation(permutation_size).each do |permutation|
    return permutation.reduce(&:*) if permutation.sum == target
  end
end

parsed_test_input = test_input.map(&:to_i)

SimpleTest.assert_equal(
  multiple_when_sum_equals(parsed_test_input, 2020),
  514_579
)

SimpleTest.assert_equal(
  multiple_when_sum_equals(parsed_test_input, 2020, 3),
  241_861_950
)

present_answer(multiple_when_sum_equals(input.map(&:to_i), 2020))
present_answer(multiple_when_sum_equals(input.map(&:to_i), 2020, 3))
