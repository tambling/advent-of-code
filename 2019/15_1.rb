require_relative './aoc_helper'

INVERSES = { north: :south, south: :north, east: :west, west: :east }

class Robot
  DIRECTIONS = [:north, :south, :west, :east]

  def initialize(sequence, map)
    @brain = IntcodeEvaluator.new(sequence)
    @map = map
    @map.set_at(x: 0, y: 0)
    @location = { x: 0, y: 0 }
    @visit = Visit.new()
    @origin = @visit
    @visit.visit!
    @direction = nil
    @current_square_type = nil
    @oxygen = false
  end

  def depth_first_search
    evaluate_surroundings
    while @visit.unvisited_neighbors? || @visit.previous
      if @visit.unvisited_neighbors?
        visit_next_unvisited
      else
        backtrack_until_unvisited
      end
      evaluate_surroundings
    end
    @map.flood_with_oxygen
  end

  def visit_next_unvisited
    go @visit.next_unvisited_direction
  end

  def backtrack_until_unvisited
    while !@visit.unvisited_neighbors?
      backtrack
    end
  end

  def evaluate_surroundings
    DIRECTIONS.each do |direction|
      peek direction
    end

  end

  def step
    @brain.evaluate_to_output
    parse_result

    system('clear')
    print @map.to_s @location
  end

  def go direction
    @direction = direction
    send_direction direction
    step
    @visit = @visit.get direction
    @visit.oxygen! if @oxygen
    @visit.visit!
  end

  def peek direction
    @direction = direction
    starting_location = @location.clone
    send_direction direction
    step

    if starting_location != @location
      @direction = inverse_direction(direction)
      send_direction(@direction)
      step
      @visit.add_unvisited(direction)
    end
  end

  def backtrack
    @direction = @visit.previous_direction
    send_direction @direction
    step
    @visit = @visit.previous if @visit.previous
  end

  private
  def send_direction direction
    case direction
    when :north
      @brain.inputs = [1]
    when :south
      @brain.inputs = [2]
    when :west
      @brain.inputs = [3]
    when :east
      @brain.inputs = [4]
    end
  end

  def inverse_direction direction
    INVERSES[direction]
  end

  def parse_result
    return unless @brain.outputs.any?

    result = [:wall, :nothing, :oxygen][@brain.outputs.shift]

    @map.set_at(**relative_coordinates(@direction), type: result)

    if result == :nothing || result == :oxygen
      @location = relative_coordinates(@direction)
    end

    @oxygen = result == :oxygen
  end

  def relative_coordinates direction
    coordinates = @location.clone

    case direction
    when :north
      coordinates[:y] -= 1
    when :south
      coordinates[:y] += 1
    when :west
      coordinates[:x] -= 1
    when :east
      coordinates[:x] += 1
    end

    coordinates
  end

  def relative_square direction
    @map.at(**relative_coordinates(direction))
  end
end

class Map
  attr_reader :squares
  def initialize(squares = {})
    @squares = squares
  end

  def at x:, y:
    return nil unless @squares[y]
    @squares[y][x]
  end

  def set_at x:, y:, type: nil
    @squares[y] ||= {}
    @squares[y][x] ||= (Square.new(x, y, type))
  end

  def all_squares
    @squares.values.map(&:values).flatten
  end

  def oxygen
    all_squares.select(&:oxygen?)
  end

  def nothing
    all_squares.select(&:nothing?)
  end

  def flood_with_oxygen
    time = 0
    while nothing.any?
      oxygen.each do |oxygen_square|
        four_adjacent(x: oxygen_square.x, y: oxygen_square.y).each(&:oxygen!)
      end
      time += 1
    system('clear')
      print to_s
    end

    p time

  end

  def four_adjacent x:, y:
    [
      at(x: x+1, y: y),
      at(x: x-1, y: y),
      at(x: x, y: y-1),
      at(x: x, y: y+1)
  ].compact.select(&:nothing?)
  end


  def to_s current_location = {}
    min_y, max_y = @squares.keys.minmax
    min_x, max_x = @squares.values.map(&:keys).flatten.minmax
    field = ""

    (min_y..max_y).each do |y|
      (min_x ..max_x).each do |x|
        square = at(x: x, y: y)
        if !square 
          field += "👀"
        elsif square.wall?
          field += "🛑"
        elsif square.oxygen?
          field += "🧀"
        elsif x == current_location[:x] && y == current_location[:y]
          field += "🐁"
        else
          field += "✨"
        end
      end
      field += "\n"
    end

    field += "\n"

    field
  end
end

class Square
  attr_reader :x, :y
  def initialize(x, y, type = nil)
    @x = x
    @y = y
    @type = type
  end

  def wall?
    @type == :wall
  end

  def oxygen?
    @type == :oxygen
  end
  def oxygen!
    @type = :oxygen
  end

  def nothing?
    @type == :nothing
  end
end

class Visit
  attr_reader :previous
  def initialize(from: nil, previous: nil)
    @directions = {
      north: nil,
      south: nil,
      east: nil,
      west: nil
    }

    @directions.delete from
    @backtrack = from
    @visited = false
    @type = nil
    @previous = previous
  end

  def unvisited_neighbors?
    return false if @directions.all?(&:nil?)
    real_neighbors.any?(&:unvisited?)
  end

  def real_neighbors
    @directions.values.reject(&:nil?)
  end


  def visit!
    @visited = true
  end

  def oxygen!
    @type = :oxygen
  end

  def oxygen?
    @type == :oxygen
  end

  def bfs_levels_to_oxygen
    level_zero = [self]
    levels = [level_zero]
    while levels.last.none?(&:oxygen?)
      levels.push(levels.last.map(&:real_neighbors).flatten)
      p levels.last.length
    end

    p levels.length - 1

  end

  def unvisited?
    !@visited
  end

  def add_unvisited direction
    @directions[direction] ||= Visit.new(from: INVERSES[direction], previous: self)
  end

  def next_unvisited_direction
    unvisited_directions = @directions.select do |direction, visit|
      visit && visit.unvisited?
    end

    unvisited_directions.keys.first
  end

  def previous_direction
    @backtrack
  end

  def get direction
    if direction == @backtrack
      @previous
    else
      @directions[direction]
    end
  end
end

sequence = inputs.first.split(',').map(&:to_i)

robot = Robot.new(sequence, Map.new)
robot.depth_first_search
