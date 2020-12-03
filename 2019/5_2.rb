require_relative './aoc_helper'

class IntcodeEvaluator
  attr_reader :sequence, :outputs
  def initialize(sequence, inputs = [])
    @sequence = sequence
    @inputs = inputs 
    @outputs = []
    @pointer = 0
    @opcode = nil
    @modes = []
  end

  def evaluate
    while evaluating
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

    self
  end

  private

  def parse_instruction
    instruction = @sequence[@pointer].to_s.split('')
    @opcode = instruction.pop(2).join.to_i

    @modes = []
    while flag = instruction.pop
      @modes.push(flag == '1' ? :immediate : :position)
    end

    loop do
      break if @modes.length >= 3
      @modes.push :position
    end
  end

  def evaluating
    @opcode != 99
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

  def input!
    @sequence[@sequence[@pointer + 1]] = @inputs.first

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

# assert_equal(IntcodeEvaluator.new([1, 0, 0, 0, 99]).evaluate.sequence, [2, 0, 0, 0, 99])
# assert_equal(IntcodeEvaluator.new([2,3,0,3,99]).evaluate.sequence, [2,3,0,6,99])
# assert_equal IntcodeEvaluator.new([2,4,4,5,99,0]).evaluate.sequence, [2,4,4,5,99,9801]
# assert_equal IntcodeEvaluator.new([1,1,1,4,99,5,6,0,99]).evaluate.sequence, [30,1,1,4,2,5,6,0,99]

original_code = inputs[0].split(',').map(&:to_i)

evaluator = IntcodeEvaluator.new(original_code, [5])

present_answer(evaluator.evaluate.outputs)

