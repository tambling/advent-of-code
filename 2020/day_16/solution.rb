# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

RULE_REGEX = /([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)/.freeze
def ticket_scanning_error_rate(input)
  valid_ranges = []
  invalid_numbers = []
  in_nearby = false

  input.each do |line|
    if line =~ RULE_REGEX
      valid_ranges.concat(RULE_REGEX.match(line).captures.map(&:to_i)[1..-1].each_slice(2).to_a)
    elsif line.start_with?("nearby")
      in_nearby = true
    elsif in_nearby
      numbers = line.split(",").map(&:to_i)
      invalid_numbers.concat(numbers.reject { |number| valid_ranges.any?{ |range| number.between?(range.first, range.last) } })
    end
  end

  invalid_numbers.sum
end


def figure_out_fields(input)
  valid_ranges = {}
  invalid_numbers = []
  valid_tickets = []
  in_nearby = false
  in_your = false
  your_ticket = nil

  input.each do |line|
    if line =~ RULE_REGEX
      captures = RULE_REGEX.match(line).captures
      key = captures.first
      valid_ranges[key] = captures[1..-1].map(&:to_i).each_slice(2).to_a
    elsif line.start_with?("your")
      in_your = true
    elsif in_your
      your_ticket = line
      in_your = false
    elsif line.start_with?("nearby")
      in_nearby = true
    elsif in_nearby
      numbers = line.split(",").map(&:to_i)

      valid_tickets.push(numbers) unless numbers.any? { |number| valid_ranges.values.none?{ |ranges| ranges.any? {|range| number.between?(range.first, range.last) } } }
    end
  end

  possible_fields = valid_tickets.map do |valid_ticket|
    valid_ticket.map do |number|
      valid_ranges.keys.select do |range_key|
        ranges = valid_ranges[range_key]
        ranges.any? do |range|
          number.between?(range.first, range.last)
        end
      end
    end
  end.transpose.map do |fields| fields.reduce(&:&) end

  sorted_fields = []
  sorted_fields.concat(possible_fields.select{|field| field.length == 1}.flatten)
  while possible_fields.any? {|field| field.length > 1 }
    possible_fields.each { |fields| fields.length > 1 && fields.reject! {|field| sorted_fields.include?(field) } }
    sorted_fields.concat(possible_fields.select{|field| field.length == 1}.flatten)
  end

  byebug
  possible_fields.flatten

end


SimpleTest.assert_equal(71, ticket_scanning_error_rate(test_input))
part_2_input = <<~PT2
  class: 0-1 or 4-19
  row: 0-5 or 8-19
  seat: 0-13 or 16-19

  your ticket:
  11,12,13

  nearby tickets:
  3,9,18
  15,1,5
  5,14,9
PT2
SimpleTest.assert_equal(["row", "class", "seat"], figure_out_fields(part_2_input.split("\n")))
# present_answer(ticket_scanning_error_rate(input))

present_answer(figure_out_fields(input))

