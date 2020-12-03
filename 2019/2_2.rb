require_relative './aoc_helper'

def evaluate_intcode(code)
  i = 0
  while code[i] != 99
    if code[i] == 1
      input1 = code[code[i + 1]]
      input2 = code[code[i + 2]]
      target = code[i + 3]

      code[target] = input1 + input2

      i += 4
    elsif code[i] == 2
      input1 = code[code[i + 1]]
      input2 = code[code[i + 2]]
      target = code[i + 3]

      code[target] = input1 * input2

      i += 4
    else
      i += 1
    end
  end

  return code
end

assert_equal(evaluate_intcode([1, 0, 0, 0, 99]), [2, 0, 0, 0, 99])
assert_equal(evaluate_intcode([2,3,0,3,99]), [2,3,0,6,99])
assert_equal evaluate_intcode([2,4,4,5,99,0]), [2,4,4,5,99,9801]
assert_equal evaluate_intcode([1,1,1,4,99,5,6,0,99]), [30,1,1,4,2,5,6,0,99]

original_code = inputs[0].split(',').map(&:to_i)

(0..99).each do |noun|
  (0..99).each do |verb|
    code = original_code.clone
    code[1] = noun
    code[2] = verb

    evaluate_intcode(code)

    present_answer([noun, verb]) if code[0] == 19690720
  end
end

