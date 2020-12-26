# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

OPERATION_REGEX = /(\d+) ([\*\+]) (\d+)/
ADDITION_REGEX = /(\d+) \+ (\d+)/
MULTIPLICATION_REGEX = /(\d+) \* (\d+)/

def solve original_equation
  equation = +original_equation
  while (open_paren_index = equation.rindex("("))
    close_paren_index = equation[open_paren_index..-1].index(")") + 1
    equation.insert(open_paren_index, solve(equation.slice!(open_paren_index, close_paren_index)[1..-2]))
  end
  while equation =~ OPERATION_REGEX
    regex_match = equation.match(OPERATION_REGEX) 
    start_index = equation.index(OPERATION_REGEX)

    left, operand, right = regex_match.captures
    result = case operand
             when "*"
               left.to_i * right.to_i
             when "+"
               left.to_i + right.to_i
             end

    equation.slice! start_index, regex_match.to_s.length

    equation.insert(start_index, result.to_s)
  end

  equation
end

def janky_solve original_equation
  equation = +original_equation
  while (open_paren_index = equation.rindex("("))
    close_paren_index = equation[open_paren_index..-1].index(")") + 1
    equation.insert(open_paren_index, janky_solve(equation.slice!(open_paren_index, close_paren_index)[1..-2]))
  end
  while equation =~ ADDITION_REGEX
    regex_match = equation.match(ADDITION_REGEX)
    start_index = equation.index(ADDITION_REGEX)

    left, right = regex_match.captures
    result = left.to_i + right.to_i
    equation.slice! start_index, regex_match.to_s.length

    equation.insert(start_index, result.to_s)
  end

  while equation =~ MULTIPLICATION_REGEX
    regex_match = equation.match(MULTIPLICATION_REGEX)
    start_index = equation.index(MULTIPLICATION_REGEX)

    left, right = regex_match.captures
    result = left.to_i * right.to_i
    equation.slice! start_index, regex_match.to_s.length

    equation.insert(start_index, result.to_s)
  end
  equation
end

# SimpleTest.assert_equal(26, solve("2 * 3 + (4 * 5)").to_i)
# SimpleTest.assert_equal(437, solve("5 + (8 * 3 + 9 + 3 * 4 * 3)").to_i)
# SimpleTest.assert_equal(12240, solve("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))").to_i)
# SimpleTest.assert_equal(13632, solve("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2").to_i)
SimpleTest.assert_equal(23340, janky_solve("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2").to_i)
present_answer(input.map { |line| janky_solve(line).to_i }.sum)
