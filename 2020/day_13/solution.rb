# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def earliest_bus(departure_time, lines)
  line_waits = {}
  lines = lines.split(",").select! { |line| line.to_i.positive? }
  lines.map(&:to_i).each do |line|
    line_waits[line - (departure_time % line)] = line
  end

  line_waits[line_waits.keys.min] * line_waits.keys.min
end

def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end
  return last_remainder, last_x * (a < 0 ? -1 : 1)
end
 
def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'Multiplicative inverse modulo does not exist!'
  end
  x % et
end
 
def crt(mods, remainders)
  max = mods.inject( :* )  # product of all moduli
  series = remainders.zip(mods).map{ |r,m| (r * max * invmod(max/m, m) / m) }
  series.inject( :+ ) % max 
end

def find_earliest_stagger(lines)
  waits = (0...lines.length).map do |i|
    -i unless lines[i].zero?
  end.compact

  crt(lines.reject(&:zero?), waits)
end

SimpleTest.assert_equal(295, earliest_bus(test_input.first.to_i, test_input.last))
SimpleTest.assert_equal(3417, find_earliest_stagger([17,0,13,19]))
SimpleTest.assert_equal(1202161486, find_earliest_stagger([1789, 37, 47, 1889]))

present_answer(find_earliest_stagger(input.last.split(",").map(&:to_i)))

