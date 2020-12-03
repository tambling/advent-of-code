require_relative './aoc_helper'
require 'benchmark'

def lawed_frequency_transmission input
  raw_input = [0] + input

  result = (1..raw_input.length/2).map { |repeat|
    relevant_numbers = raw_input.each_slice(repeat)
      .to_a
      .select.with_index{|_, i| i.odd? }

    positives = relevant_numbers.select.with_index{|_, i| i.even?}
    negatives = relevant_numbers.select.with_index{|_, i| i.odd?}

    (positives.flatten.sum - negatives.flatten.sum).abs % 10
  }

  (raw_input.length / 2..1).each do |i|
    result.push raw_input.last(i).sum
  end
end


def fft_repeat input, n
  all_rounds = []
  current_input = input
  all_rounds << current_input
  n.times do |current_n|
    current_input = new_flawed_frequency_transmission(current_input)

    all_rounds << current_input
  end

  all_rounds
end

def fft_repeating_string input, repeat
end


p Benchmark.realtime { flawed_frequency_transmission(inputs.first* 100)}

