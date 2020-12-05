# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def seat_id(binary_partition)
  rows = (0..127).to_a
  row_partition = binary_partition.split("").first(7)

  row_partition.each do |code|
    rows = halve_array(rows, code)
  end

  columns = (0..7).to_a
  column_partition = binary_partition.split("").last(3)

  column_partition.each do |code|
    columns = halve_array(columns, code)
  end

  rows.first * 8 + columns.first
end

def halve_array(array, code)
  if %w[F L].include? code
    array[0..(array.length / 2) - 1]
  else
    array[(array.length / 2)..-1]
  end
end

SimpleTest.assert_equal(567, seat_id("BFFFBBFRRR"))

seat_ids = input.map do |partition|
  seat_id(partition)
end

present_answer(seat_ids.max)

seat_ids.sort!

seat_ids.each_with_index do |seat_id, i|
  present_answer(seat_id - 1) if i > 1 && seat_id - seat_ids[i - 1] == 2
end

