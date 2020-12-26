# frozen_string_literal: true

require_relative "../../helper"
require_relative "../intcode_evaluator"

setup_inputs(__FILE__)

def evaluate_intcode(code)
  IntcodeEvaluator.new(code).evaluate.sequence
end

SimpleTest.assert_equal([2, 0, 0, 0, 99], evaluate_intcode([1, 0, 0, 0, 99]))
SimpleTest.assert_equal([2, 3, 0, 6, 99], evaluate_intcode([2, 3, 0, 3, 99]))
SimpleTest.assert_equal([2, 4, 4, 5, 99, 9801], evaluate_intcode([2, 4, 4, 5, 99, 0]))
SimpleTest.assert_equal([30, 1, 1, 4, 2, 5, 6, 0, 99], evaluate_intcode([1, 1, 1, 4, 99, 5, 6, 0, 99]))

original_code = input[0].split(",").map(&:to_i)

first_pass_code = original_code.clone
first_pass_code[1] = 12
first_pass_code[2] = 2
SimpleTest.assert_equal(4_945_026, evaluate_intcode(first_pass_code)[0])

(0..99).each do |noun|
  (0..99).each do |verb|
    code = original_code.clone
    code[1] = noun
    code[2] = verb

    evaluate_intcode(code)

    present_answer([noun, verb]) if code[0] == 19_690_720
  end
end
