require_relative './aoc_helper'

assert_equal(IntcodeEvaluator.new([1, 0, 0, 0, 99]).evaluate.sequence, [2, 0, 0, 0, 99])
assert_equal(IntcodeEvaluator.new([2,3,0,3,99]).evaluate.sequence, [2,3,0,6,99])
assert_equal IntcodeEvaluator.new([2,4,4,5,99,0]).evaluate.sequence, [2,4,4,5,99,9801]
assert_equal IntcodeEvaluator.new([1,1,1,4,99,5,6,0,99]).evaluate.sequence, [30,1,1,4,2,5,6,0,99]

first_fixture = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]

assert_equal(IntcodeEvaluator.new(first_fixture).evaluate.outputs, first_fixture)

assert(IntcodeEvaluator.new([1102,34915192,34915192,7,4,7,99,0]).evaluate.outputs.first.to_s.length == 16)
assert_equal(1125899906842624, IntcodeEvaluator.new([104,1125899906842624,99]).evaluate.outputs.first)

sequence = inputs.first.split(',').map(&:to_i)
evaluator = IntcodeEvaluator.new(sequence, [2])
evaluator.evaluate

p evaluator.sequence

# present_answer(IntcodeEvaluator.new(sequence, [2]).evaluate.outputs)
