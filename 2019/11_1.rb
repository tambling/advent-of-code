require_relative './aoc_helper'

class Robot
  DIRECTIONS = [:up, :right, :down, :left]

  attr_reader :panels_painted

  def initialize(sequence, field)
    @brain = IntcodeEvaluator.new(sequence)
    @field = field
    @panels_painted = []
    @coordinates = { x: 0, y: 0 }
    @current_color = :white
    @current_direction = :up
  end

  def run
    while @brain.evaluating?
      input_color
      grab_two_outputs
      paint_if_necessary
      determine_direction
      advance
      clear_outputs
    end
  end


  private
  def input_color
    @current_color = if @field.white?(@coordinates)
                       :white
                     else
                       :black
                     end

    @current_color == :black ? @brain.add_input(0) : @brain.add_input(1)
  end

  def grab_two_outputs
    @brain.evaluate_to_outputs(2)
  end

  def paint_if_necessary
    desired_color = @brain.outputs.first == 0 ? :black : :white

    desired_color == :black ? 
      @field.black!(@coordinates) :
      @field.white!(@coordinates)

    @panels_painted.push @coordinates.clone
  end

  def determine_direction
    desired_spin = @brain.outputs.last == 0 ? :counter : :clockwise
    @current_direction = if desired_spin == :clockwise
                           DIRECTIONS[(DIRECTIONS.index(@current_direction) + 1) % 4]
                         else
                           DIRECTIONS[(DIRECTIONS.index(@current_direction) - 1) % 4]
                         end
  end

  def advance
    case @current_direction
    when :up
      @coordinates[:y] -= 1
    when :down
      @coordinates[:y] += 1
    when :left
      @coordinates[:x] -= 1
    when :right
      @coordinates[:x] += 1
    end
  end

  def clear_outputs
    2.times do
      @brain.outputs.shift
    end
  end
end


class ColorField
attr_reader :white_squares
  def initialize
    @white_squares = [{x: 0, y:0}]
  end

  def white?(coordinates)
    !black?(coordinates)
  end

  def black?(coordinates)
    !@white_squares.index(coordinates)
  end

  def white!(coordinates)
    @white_squares.push(coordinates.clone)
  end

  def black!(coordinates)
    @white_squares.reject! { |c| c == coordinates }
  end

  def print
    coordinates = normalize_coordinates

    maximum_x = coordinates.map { |square| square[:x] }.max
    maximum_y = coordinates.map { |square| square[:y] }.max

    string = ""
    (0..maximum_y).each do |row|
      (0..maximum_x).each do |cell|
        char = coordinates.index({ x: cell, y: row}) ? "•" : " "
        string += char
      end
      string += "\n"
    end

    string
  end

  private

  def normalize_coordinates
    minimum_x = @white_squares.map { |square| square[:x] }.min
    minimum_y = @white_squares.map { |square| square[:y] }.min

    @white_squares.map do |square|
      { x: square[:x] - minimum_x, y: square[:y] - minimum_y }
    end
  end
end

sequence = inputs.first.split(',').map(&:to_i)
field = ColorField.new
robot = Robot.new(sequence, field)

robot.run
puts field.print

