require_relative './aoc_helper'

class ScaffoldSeer
  def initialize(sequence)
    @brain = IntcodeEvaluator.new(sequence)
    @brain.evaluate
    parse_output
  end

  def find_intersections
    @intersections = []

    @points.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell == '#' && all_neighbors_intersection?(x, y)
          @intersections << [x, y]
        end
      end
    end

    @intersections
  end

  def sum_intersections
    @intersections.map { |intersection|
      intersection.first * intersection.last
    }.sum
  end



  private 

  def parse_output
    @map = @brain.outputs.map(&:chr).join
    puts @map
    @points = @map.split("\n").map { |line| line.split('') }
  end

  def all_neighbors_intersection? x, y
    return false unless (x - 1 >= 0) && (y - 1 >= 0)
    return false unless ((x + 1) < @points.first.length) && ((y + 1) < @points.length)

    neighbors = [
      @points[y + 1][x],
      @points[y - 1][x],
      @points[y][x + 1],
      @points[y][x - 1]
    ]

    neighbors.all? { |neighbor| neighbor == '#' }
  end
end

sequence = inputs.first.split(',').map(&:to_i)

seer =  ScaffoldSeer.new(sequence)

manual_sequence = "L,12,L,10,R,8,L,12,R,8,R,10,R,12,L,12,L,10,R,8,L,12,R,8,R,10,R,12,L,10,R,12,R,8,L,10,R,12,R,8,R,8,R,10,R,12,L,12,L,10,R,8,L,12,R,8,R,10,R,12,L,10,R,12,R,8"

def expand_manual_sequence(sequence)
  string = ""
  sequence.split(',').each do |instruction|
    if instruction == 'L' || instruction == 'R'
      string += instruction
    elsif instruction.to_i
      instruction.to_i.times do 
      string += "F"
      end
    end
  end
  string

end

expanded_sequence =  expand_manual_sequence(manual_sequence)

def find_repeated_sequence string, offset
  i = offset
  while string[i..-1].include?(string[offset..offset + i])
    i += 1
  end

  return string[offset..offset + i - 1]
end

def compress string
  keys = ['A', 'B', 'C']
  compression = {}
  compressed_string = string
  offset = 0
  keys.each_with_index do |key|
    compression[key] = find_repeated_sequence(compressed_string, offset)
    offset += compression[key].length - 1
  end

  compression.each do |key, value|
    byebug
    compressed_string.gsub!(value, key)
  end

  compressed_string

end

p compress(expanded_sequence)
