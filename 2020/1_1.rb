require_relative "../aoc_helper"

def multiple_when_sum_equals(inputs, target, permutation_size = 2)
  inputs.permutation(permutation_size).each do |permutation|
    return permutation.reduce(&:*) if permutation.sum == target
  end
end

test_fixture = [
  1721,
  979,
  366,
  299,
  675,
  1456
]

assert_equal(multiple_when_sum_equals(test_fixture, 2020), 514579)
assert_equal(multiple_when_sum_equals(test_fixture, 2020, 3), 241861950)

present_answer(multiple_when_sum_equals(inputs.map(&:to_i), 2020))
present_answer(multiple_when_sum_equals(inputs.map(&:to_i), 2020, 3))
