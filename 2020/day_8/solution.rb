# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

ANOTHER_BLOODY_REGEX = /(?<instruction>nop|acc|jmp) (?<quantity>[+-]\d+)/.freeze

def accumulator_at_halt(instructions, repair: false, index_to_flip: 0)
  accumulator = 0
  index = 0
  visited_instructions = []
  flipped_instruction = nil

  until visited_instructions.include?(index) || index == instructions.length
    visited_instructions.push(index)
    raw_instruction = instructions[index]
    parsed_instruction = ANOTHER_BLOODY_REGEX.match(raw_instruction)

    instruction = if repair && index == index_to_flip
                    flipped_instruction = parsed_instruction[:instruction]

                    if flipped_instruction == "jmp"
                      "nop"
                    else
                      "jmp"
                    end
                  else
                    parsed_instruction[:instruction]
                  end

    case instruction
    when "nop"
      index += 1
    when "acc"
      accumulator += parsed_instruction[:quantity].to_i
      index += 1
    when "jmp"
      index += parsed_instruction[:quantity].to_i
    end
  end

  return accumulator unless repair

  if index == instructions.length && flipped_instruction != "acc"
    accumulator
  else
    accumulator_at_halt(instructions, repair: true, index_to_flip: index_to_flip + 1)
  end
end

SimpleTest.assert_equal(5, accumulator_at_halt(test_input))
SimpleTest.assert_equal(8, accumulator_at_halt(test_input, repair: true))
