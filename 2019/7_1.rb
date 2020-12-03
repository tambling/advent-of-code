require_relative './aoc_helper'

class IntcodeEvaluator
  attr_reader :sequence, :outputs
  def initialize(sequence, static_inputs = [], input_provider = nil)
    @sequence = sequence
    @static_inputs = static_inputs 
    @input_provider = input_provider
    @outputs = []
    @pointer = 0
    @opcode = nil
    @modes = []
  end

  def evaluate
    while evaluating?
      evaluate_next
    end

    self
  end

  def evaluate_to_output
    while evaluating? && @outputs.none?
      evaluate_next
      break if !evaluating?
    end
  end

  def evaluate_next
    parse_instruction

    if add?
      add!
    elsif multiply?
      multiply!
    elsif input?
      input!
    elsif output?
      output!
    elsif jump_if_true?
      jump_if_true!
    elsif jump_if_false?
      jump_if_false!
    elsif less_than?
      less_than!
    elsif equals?
      equals!
    else
      advance!
    end
  end

  def evaluating?
    @opcode != 99
  end

  def add_static_inputs input
    @static_inputs.push(*input)
  end

  def set_input_provider computer
    @input_provider = computer
  end

  private

  def parse_instruction
    instruction = @sequence[@pointer].to_s.split('')
    @opcode = instruction.pop(2).join.to_i

    @modes = []
    while flag = instruction.pop
      @modes.push(flag == '1' ? :immediate : :position)
    end

    while @modes.length < 3
      @modes.push :position
    end
  end

  def add?
    @opcode == 1
  end

  def add!
    input1, input2 = values

    if @modes.last == :immediate
      @sequence[@pointer + 3] = input1 + input2
    else
      @sequence[@sequence[@pointer + 3]] = input1 + input2
    end

    @pointer += 4
  end

  def multiply?
    @opcode == 2
  end

  def multiply!
    input1, input2 = values

    if @modes.last == :immediate
      @sequence[@pointer + 3] = input1 * input2
    else
      @sequence[@sequence[@pointer + 3]] = input1 * input2
    end

    @pointer += 4
  end

  def input?
    @opcode == 3
  end

  def inputs
    if @input_provider
      [@static_inputs, @input_provider.outputs].flatten
    else
      @static_inputs
    end
  end

  def input!
    if inputs.empty?
      @input_provider.evaluate_to_output
    end

    @sequence[@sequence[@pointer + 1]] = if @static_inputs.any?
                                           @static_inputs.shift
                                         else
                                           @input_provider.outputs.shift
                                         end

    @pointer += 2
  end

  def output?
    @opcode == 4
  end

  def output!
    if @modes.first == :immediate
      @outputs.push(@sequence[@pointer + 1])
    else
      @outputs.push(@sequence[@sequence[@pointer + 1]])
    end

    @pointer += 2
  end

  def jump_if_true?
    @opcode == 5
  end

  def jump_if_true!
    if values.first != 0
      @pointer = values.last
    else
      @pointer += 3
    end
  end

  def jump_if_false?
    @opcode == 6
  end

  def jump_if_false!
    if values.first == 0
      @pointer = values.last
    else 
      @pointer += 3
    end
  end

  def less_than?
    @opcode == 7
  end

  def less_than!
    input1, input2 = values

    value = input1 < input2 ? 1 : 0

    if @modes.last == :immediate
      @sequence[@pointer + 3] = value
    else
      @sequence[@sequence[@pointer + 3]] = value
    end

    @pointer += 4
  end

  def equals?
    @opcode == 8
  end

  def equals!
    input1, input2 = values

    value = input1 == input2 ? 1 : 0

    if @modes.last == :immediate
      @sequence[@pointer + 3] = value
    else
      @sequence[@sequence[@pointer + 3]] = value
    end

    @pointer += 4
  end

  def advance!
    @pointer += 1
  end

  def position(index)
    @sequence[@sequence[index]]
  end

  def immediate(index)
    @sequence[index]
  end

  def values
    (1..2).map do |i|
      mode = @modes[i - 1]
      mode == :immediate ? immediate(@pointer + i) : position(@pointer + i)
    end

  end
end

def max_output(instruction_set)
  outputs = (0..4).to_a.permutation.map do |phase_sequence|
    input = 0

    phase_sequence.each do |phase_setting|
      computer = IntcodeEvaluator.new(instruction_set.clone, [phase_setting, input])
      computer.evaluate
      input = computer.outputs.last
    end

    input
  end

  return outputs.max
end

def feedback_output(instruction_set)
  outputs = (5..9).to_a.permutation.map do |phase_sequence|
    computers = phase_sequence.map do |phase_setting|
      IntcodeEvaluator.new(instruction_set.clone, [phase_setting])
    end

    computers.first.add_static_inputs [0]

    computers.each_with_index do |computer, i|
      computers[(i + 1) % 5].set_input_provider computer
    end

    computers.last.evaluate

    computers.last.outputs.last
  end

  return outputs.max
end



first_fixture = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
assert_equal(43210, max_output(first_fixture))
second_fixture = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
assert_equal(54321, max_output(second_fixture))
third_fixture = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
assert_equal(65210, max_output(third_fixture))

fourth_fixture = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]
assert_equal(139629729, feedback_output(fourth_fixture))

fifth_fixture = [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
                 -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
                 53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10]
assert_equal(18216, feedback_output(fifth_fixture))
