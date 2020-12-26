# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

MASK_REGEX = /mask = ([X01]+)/.freeze
VALUE_REGEX = /mem\[(?<address>\d+)\] = (?<value>\d+)/.freeze

def sum_after_completion(program)
  memory = {}
  mask = "X" * 36

  program.each do |line|
    if line =~ MASK_REGEX
      mask = MASK_REGEX.match(line).captures.first
    elsif line =~ VALUE_REGEX
      value_matches = VALUE_REGEX.match(line)
      address = value_matches[:address]
      dec_value = value_matches[:value].to_i
      value = dec_value.to_s(2).rjust(36, "0")
      raise unless value_matches[:value].to_i == value.to_i(2)

      masked_bits = value.split("").each_with_index.map do |bit, i|
        if (mask_bit = mask[i]) != "X"
          mask_bit
        else
          bit
        end
      end

      memory[address] = masked_bits.join.to_i(2)
    end
  end

  memory.values.sum
end

def floating_sum_after_completion(program)
  memory = {}
  mask = "0" * 36

  program.each do |line|
    if line =~ MASK_REGEX
      mask = MASK_REGEX.match(line).captures.first
    elsif line =~ VALUE_REGEX
      value_matches = VALUE_REGEX.match(line)
      address = value_matches[:address].to_i.to_s(2).rjust(36, "0")
      value = value_matches[:value].to_i

      masked_bits = address.split("").each_with_index.map do |bit, i|
        if (mask_bit = mask[i]) != "0"
          mask_bit
        else
          bit
        end
      end

      ["0", "1"].repeated_permutation(masked_bits.count("X")).each do |permutation|
        x_count = 0

        unmasked_bits = masked_bits.map do |bit|
          if bit == "X"
            new_bit = permutation[x_count]
            x_count += 1
            new_bit
          else
            bit
          end
        end
        memory[unmasked_bits.join.to_i(2)] = value
      end
    end
  end
  memory.values.sum
end


# SimpleTest.assert_equal(165, sum_after_completion(test_input))

# present_answer(sum_after_completion(input))
part_2_program = <<~FUCK
  mask = 000000000000000000000000000000X1001X
  mem[42] = 100
  mask = 00000000000000000000000000000000X0XX
  mem[26] = 1
FUCK

# SimpleTest.assert_equal(208, floating_sum_after_completion(part_2_program.split("\n")))
present_answer(floating_sum_after_completion(input))
