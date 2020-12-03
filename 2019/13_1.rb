require './aoc_helper'

class ArcadeCabinet
  attr_reader :entities, :score

  def initialize sequence
    @cpu = IntcodeEvaluator.new(sequence)
    @screen = []
    @ball = nil
    @paddle = nil
    @score = nil
    @previous_ball_x = 0
    @joystick = 0
  end

  def run
    while @cpu.evaluating?
      step
    end
  end

  def step
    @cpu.evaluate_next
    parse_output
    determine_ball_direction
    pass_joystick
    print_screen
  end

  def to_s
    height = @screen.length
    width = @screen.map {|row| row || [] }.map(&:length).max
    string = "\r"
    characters = [" ", "X", "X", "-", "O"]

    height.times do |row|
      width.times do |column|
        if @screen[row][column]
          string += characters[@screen[row][column]]
        else
          string += " "
        end
      end
      string += "\n"
    end
    string
  end

  def print_screen
    print to_s
    system 'clear'
  end

  private

  def parse_output
    if @cpu.outputs.length == 3
      raw_entity = @cpu.outputs.shift(3)
      if raw_entity && raw_entity.length == 3
        if raw_entity[0] == -1 && raw_entity[1] == 0
          @score = raw_entity[2]
        else
          @screen[raw_entity[1]] ||= []
          @screen[raw_entity[1]][raw_entity[0]] = raw_entity[2]
          
          if raw_entity[2] == 3
            @paddle = {x: raw_entity[0], y: raw_entity[1]}
          elsif raw_entity[2] == 4
            @ball = {x: raw_entity[0], y: raw_entity[1]}
          end
        end
      end
    end
  end

  def determine_ball_direction
    return unless @ball && @paddle
    ball_x = @ball[:x]
    paddle_x = @paddle[:x]

    @joystick = ball_x <=> paddle_x
  end

  def pass_joystick
    @cpu.inputs = [@joystick]
  end
end

sequence = inputs.first.split(',').map(&:to_i)

cabinet = ArcadeCabinet.new(sequence)
cabinet.run


present_answer(cabinet.score)
