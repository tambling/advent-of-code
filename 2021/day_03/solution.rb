# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def solution(numbers)
  digits_by_place = numbers.map { |number| 
    number.split("") }.transpose.map(&:reverse)

  gamma_digits = digits_by_place.map do |place|
    place.max_by { |digit| place.count(digit) }
  end

  epsilon_digits = digits_by_place.map do |place|
    place.min_by { |digit| place.count(digit) }
  end

  gamma = gamma_digits.join.to_i(2)
  epsilon = epsilon_digits.join.to_i(2)

  gamma * epsilon
end

def solution_part_2(numbers)
  mcn = most_common_number(numbers.clone).join.to_i(2)
  lcn = least_common_number(numbers.clone).join.to_i(2)

  mcn * lcn
end

def most_common_number(numbers)
  (0...numbers.first.length).each do |i|
    digit = numbers.count {|n| n[i] == "0"} > (numbers.length / 2) ? "0" : "1"
  
    numbers = numbers.filter { |n| n[i] == digit }
    return numbers if numbers.length == 1
  end

  numbers


end

def least_common_number(numbers)
  (0..numbers.first.length).each do |i|
    digit = numbers.count {|n| n[i] == "0"} <= (numbers.length / 2) ? "0" : "1"
  
    numbers = numbers.filter { |n| n[i] == digit }
    return numbers if numbers.length == 1
  end

end
SimpleTest.assert_equal(198, solution(test_input))
SimpleTest.assert_equal(230, solution_part_2(test_input))

present_answer(solution_part_2(input))
