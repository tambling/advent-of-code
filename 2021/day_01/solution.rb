# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def solution(measurements, window: 1)
  sums = measurements.each_cons(window).map(&:sum)
  sums.each_cons(2).count { |a, b| b > a }
end

test_measurements = test_input.map(&:to_i)
SimpleTest.assert_equal(7, solution(test_measurements))
SimpleTest.assert_equal(5, solution(test_measurements, window: 3))
