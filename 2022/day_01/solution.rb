# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def solution(calorie_count_list, top: 1)
  calorie_count_list.split("\n\n").map do |elf_calories|
    elf_calories.split("\n").map(&:to_i).sum
  end.max(top).first(top)
end

SimpleTest.assert_equal(24000, solution(test_input(raw: true)).first)
present_answer(solution(input(raw: true)))
present_answer(solution(input(raw: true), top: 3).sum)
