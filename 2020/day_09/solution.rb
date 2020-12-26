# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def first_nonconforming_number(sequence, preamble_length: 25)
  (preamble_length..sequence.length).each do |i|
    return sequence[i] unless sequence[i - preamble_length..i].combination(2).any? { |combo| combo.first + combo.last == sequence[i] }
  end
end

def blackjack_sum(sequence, target)
  (0..sequence.length).each do |i|
    total = 0
    span = 1
    while total < target
      total += sequence[i + span]
      span += 1
    end

    if total == target
      matching_sequence = sequence[i..i+span- 1]
      return matching_sequence.min + matching_sequence.max
    end
  end
end


SimpleTest.assert_equal(127, first_nonconforming_number(test_input.map(&:to_i), preamble_length: 5))
SimpleTest.assert_equal(62, blackjack_sum(test_input.map(&:to_i), 127))
first_answer = first_nonconforming_number(input.map(&:to_i))
present_answer(first_answer)
present_answer(blackjack_sum(input.map(&:to_i), first_answer))
