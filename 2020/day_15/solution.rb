# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def nth_number_spoken(sequence, n)
  number_instances = {}
  current_number = 0
  (0...n).each do |i|
    current_number = if i < sequence.length
                       sequence[i]
                     elsif !number_instances.include?(current_number) || number_instances[current_number].length < 2
                       0
                     else
                       number_instances[current_number][-1] - number_instances[current_number][-2]
                     end

    number_instances[current_number] ||= []
    number_instances[current_number].push(i + 1)
  end

  current_number
end

SimpleTest.assert_equal(1, nth_number_spoken([1,3,2], 2020))
SimpleTest.assert_equal(10, nth_number_spoken([2,1,3], 2020))
present_answer(nth_number_spoken([0,20,7,16,1,18,15], 30000000))
