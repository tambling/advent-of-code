# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def solution(instructions)
  numbers = instructions.shift.split(",").map(&:to_i)

  boards = []
  instructions.each_slice(6) do |raw_board|
    raw_board.shift
    boards << Board.new(raw_board.map { |raw_row| raw_row.split(" ").map(&:to_i) } )
  end

  numbers.each do |number|
    boards.each { |board| board.mark(number) }
    if boards.any?(&:victory?) && boards.length == 1
      return number * boards.last.score
    end
    boards.reject!(&:victory?)
  end
end

class Board
  attr_reader :rows

  def initialize(rows)
    @rows = rows
  end

  def mark(number)
    rows.each do |row|
      row.map! { |cell| cell == number ? nil : cell }
    end
  end

  def score
    rows.map { |row| row.compact.sum }.compact.sum
  end

  def victory?
    horizontal_victory? || vertical_victory?
  end

  def horizontal_victory?
    rows.any? { |row| row.all?(&:nil?) }
  end

  def vertical_victory?
    (0..4).any? { |i| rows.map { |row| row[i] }.all?(&:nil?) }
  end
end

SimpleTest.assert_equal(1924, solution(test_input))

present_answer(solution(input))
