require_relative './aoc_helper'

class AsteroidFinder
  attr_reader :asteroids

  def initialize(field)
    @field = field
    @asteroids = []

    parse_asteroids
  end

  def best_detector
    @asteroids.max_by(&:visible_count)
  end

  private

  def parse_asteroids
    asteroid_matrix = @field.split("\n").map { |row| row.split('') }

    asteroid_matrix.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell == '#'
          @asteroids.push Asteroid.new(x: x, y: y)
        end
      end
    end

    @asteroids.each do |asteroid|
      asteroid.calculate_visible(@asteroids)
    end
  end

end

class Asteroid
  attr_reader :x, :y, :lines_of_sight

  def initialize(x:, y:)
    @x = x
    @y = y
    @lines_of_sight = {}
  end

  def calculate_visible asteroids
    asteroids.each do |asteroid|
      if !(asteroid.x == @x && asteroid.y == @y)
        @lines_of_sight[calculate_slope(asteroid)] ||= {}
        @lines_of_sight[calculate_slope(asteroid)][calculate_distance(asteroid
                                                                     )] = [asteroid.x, asteroid.y]
      end
    end
  end

  def visible_count
    @lines_of_sight.keys.length
  end

  def vaporize_to_200
    vaporized = 0
    clockwise = @lines_of_sight.keys.sort do |a, b|
      b <=> a
    end
    clockwise.rotate!(clockwise.index(Math::PI / 2))

    twohundth = []

    while vaporized < 200
      clockwise.each do |los|
        p los
        distance = @lines_of_sight[los].keys.min
        coordinates = @lines_of_sight[los].delete(distance)
        vaporized += 1

        if @lines_of_sight[los].empty?
          @lines_of_sight.delete(los)
        end

        (twohundth = coordinates) if vaporized == 200
      end
    end

    twohundth
  end
    
  def to_a
    [[x, y], visible_count]
  end

  private

  def calculate_slope(asteroid)
    rise = @y - asteroid.y 
    run = asteroid.x - @x

    return Math.atan2(rise, run)
  end

  def calculate_distance(asteroid)
    rise = @y - asteroid.y 
    run = @x - asteroid.x

    Math.sqrt(rise ** 2 + run ** 2)
  end
end

#toy = <<-FIELD
#.#..#
#.....
######
#....#
#...##
#FIELD

#first_fixture = <<-FIELD
#......#.#.
##..#.#....
#..#######.
#.#.#.###..
#.#..#.....
#..#....#.#
##..#....#.
#.##.#..###
###...#..#.
#.#....####
#FIELD

#assert_equal([[5, 8], 33], AsteroidFinder.new(first_fixture).best_detector.to_a)

#second_fixture = <<-FIELD
##.#...#.#.
#.###....#.
#.#....#...
###.#.#.#.#
#....#.#.#.
#.##..###.#
#..#...##..
#..##....##
#......#...
#.####.###.
#FIELD

#assert_equal([[1, 2], 35], AsteroidFinder.new(second_fixture).best_detector)

#third_fixture = <<-FIELD
#.#..#..###
#####.###.#
#....###.#.
#..###.##.#
###.##.#.#.
#....###..#
#..#.#..#.#
##..#.#.###
#.##...##.#
#.....#.#..
#FIELD
#assert_equal([[6, 3], 41], AsteroidFinder.new(third_fixture).best_detector)

#fourth_fixture = <<-FIELD
#.#..##.###...#######
###.############..##.
#.#.######.########.#
#.###.#######.####.#.
######.##.#.##.###.##
#..#####..#.#########
#####################
##.####....###.#.#.##
###.#################
######.##.###..####..
#..######..##.#######
#####.##.####...##..#
#.#####..#.######.###
###...#.##########...
##.##########.#######
#.####.#.###.###.#.##
#....##.##.###..#####
#.#.#.###########.###
##.#.#.#####.####.###
####.##.####.##.#..##
#FIELD

#assert_equal([[11, 13], 210], AsteroidFinder.new(fourth_fixture).best_detector)

fifth_fixture = <<-FIELD
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
FIELD

assert_equal([8,2], AsteroidFinder.new(fifth_fixture).best_detector.vaporize_to_200)

field = inputs.join "\n"

base =AsteroidFinder.new(field).best_detector

p base.vaporize_to_200
    
