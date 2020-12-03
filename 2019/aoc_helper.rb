require 'test/unit'
require 'byebug'

include Test::Unit::Assertions

def inputs
  file = File.read(ARGV[0])
  lines = file.split("\n")

  return lines
end

def present_answer(answer)
  puts "The answer is #{answer}"
end

class IntcodeEvaluator
  attr_reader :sequence, :outputs, :opcode
  attr_accessor :inputs
  def initialize(sequence, inputs = [])
    @sequence = sequence.clone
    @inputs = inputs 
    @outputs = []
    @pointer = 0
    @opcode = nil
    @modes = []
    @relative_base = 0
  end

  def evaluate
    while evaluating?
      evaluate_next
    end

    self
  end

  def evaluate_to_output
    while evaluating? && !output?
      evaluate_next
    end

    evaluate_next
  end

  def evaluate_to_outputs(n)
    while evaluating? && @outputs.length < n
      evaluate_next
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
    elsif adjust_relative_base?
      adjust_relative_base!
    else
      advance!
    end
  end
  
  def add_input input
    @inputs.push input
  end

  def evaluating?
    @opcode != 99
  end

  private

  def parse_instruction
    instruction = @sequence[@pointer].to_s.split('')
    @opcode = instruction.pop(2).join.to_i

    @modes = []
    while flag = instruction.pop

      mode = case flag.to_i
             when 0
               :position
             when 1
               :immediate
             when 2
               :relative
             end 
      @modes.push(mode)
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

    set_at(@pointer + 3, @modes.last, input1 + input2)

    @pointer += 4
  end

  def multiply?
    @opcode == 2
  end

  def multiply!
    input1, input2 = values

    set_at(@pointer + 3, @modes.last, input1 * input2)

    @pointer += 4
  end

  def input?
    @opcode == 3
  end

  def input!
              input = @inputs.shift

    set_at(@pointer + 1, @modes.first, input)

    @pointer += 2
  end

  def output?
    @opcode == 4
  end

  def output!
    @outputs.push(get_at(@pointer + 1, @modes.first))

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

    set_at(@pointer + 3, @modes.last, value)

    @pointer += 4
  end

  def equals?
    @opcode == 8
  end

  def equals!
    input1, input2 = values

    value = input1 == input2 ? 1 : 0

    set_at(@pointer + 3, @modes.last, value)

    @pointer += 4
  end

  def adjust_relative_base?
    @opcode == 9
  end

  def adjust_relative_base!
    @relative_base += get_at(@pointer + 1, @modes.first)
    
    @pointer += 2
  end

  def advance!
    @pointer += 1
  end

  def position(index)
    @sequence[index] || 0
  end

  def immediate(index)
    index
  end

  def relative(index)
    @relative_base + @sequence[index]
  end

  def get_at(i, mode)
    index = case mode
            when :immediate
              immediate(i)
            when :position
              position(i)
            when :relative
              relative(i)
            end
    @sequence[index] || 0
  end

  def set_at(i, mode, value)
    index = case mode
            when :immediate
              immediate(i)
            when :position
              position(i)
            when :relative
              relative(i)
            end
    @sequence[index] = value
  end

  def values
    (1..2).map do |i|
      mode = @modes[i - 1]
      get_at(@pointer + i, mode)
    end
  end
end
