# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def yes_answers(raw_answers, intersect: false)
  answers = raw_answers.split("\n")
  answers.map! do |answer|
    answer.chomp.split("")
  end

  if intersect
    answers.reduce(&:&).length
  else
    answers.flatten.uniq.length
  end
end

SimpleTest.assert_equal(3, yes_answers("abc"))
SimpleTest.assert_equal(3, yes_answers("a\nb\nc"))
SimpleTest.assert_equal(1, yes_answers("a\na\na"))

parsed_input = input(raw: true).split("\n\n")
answer = parsed_input.map { |raw_answers| yes_answers(raw_answers) }.sum
present_answer(answer)

SimpleTest.assert_equal(3, yes_answers("abc", intersect: true))
SimpleTest.assert_equal(0, yes_answers("a\nb\nc\n", intersect: true))

second_answer = parsed_input.map { |raw_answers| yes_answers(raw_answers, intersect: true) }.sum
present_answer(second_answer)
