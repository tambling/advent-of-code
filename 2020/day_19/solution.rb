# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

RULE_REGEX = /(\d+): (.+)/.freeze

MESSAGE_REGEX = /[ab]+/.freeze

def matching_lines(input)
  rules = {}
  messages = []

  input.each do |input_line|
    if input_line =~ RULE_REGEX
      rule_number, rule = input_line.match(RULE_REGEX).captures
      rules[rule_number.to_i] = rule
    elsif input_line =~ MESSAGE_REGEX
      messages.push(input_line)
    end
  end

  rules.each do |rule_number, rule|
    rules[rule_number] = parse_rule(rule)
  end

  while rules.values.any? { |rule| !fully_parsed?(rule) }
    rules.each do |rule_number, rule|
      all_clauses = rule.flatten.uniq

      if all_clauses.all? { |clause| (clause.is_a?(Integer) && fully_parsed?(rules[clause])) || clause == rule_number }
        process_rule(rule_number, rule, rules)
      end
    end
  end

  messages.select { |message| message_matches?(message, rules[0])}
end

CLAUSE_REGEX = /(\d+)/.freeze
EXAMPLE_REGEX = /^"(\w+)"$/.freeze

def parse_rule(rule)
  if rule =~ EXAMPLE_REGEX
    character = rule.match(EXAMPLE_REGEX).captures.first
    [character]
  else
    clauses = rule.split(" | ")
    clauses.map { |clause| clause.scan(CLAUSE_REGEX).flatten.map(&:to_i) }
  end
end

def fully_parsed?(rule)
  rule.all? { |clause| clause.is_a?(String) || clause.is_a?(Regexp) }
end

def process_rule(rule_number, rule, rules)
  rules[rule_number] = if rule.last.include?(rule_number)
                         process_recursive(rule.first, rules)
                       elsif rule.all? { |clause| clause.is_a?(Integer) }
                         process_clause(rule, rules)
                       else
                         rule.map { |clause| process_clause(clause, rules) }.flatten
                       end
end

def process_clause(clause, rules)
  conditions = clause.map { |number| rules[number] }
  return conditions.flatten if conditions.flatten.all? { |condition| condition.is_a?(Regexp) }

  products = conditions.reduce { |acc, strings| acc.product(strings) }
  return products unless products.all? { |product| product.is_a?(Array) }

  products.map(&:join)
end

def process_recursive(clause, rules)
  if clause.length == 2
    [/(#{rules[clause.first].join("|")})/, /(#{rules[clause.last].join("|")})/]
  else
    [/^(#{rules[clause.first].join("|")})+/]
  end
end

def message_matches?(message, rule)
  repeating, front, back = rule

  15.downto(1).each do |i|
    regex = Regexp.new("^" + repeating.source + front.source + "{#{i}}" + back.source + "{#{i}}$")
    return true if message =~ regex
  end

  false
end


SimpleTest.assert_equal(12, matching_lines(test_input).length)
present_answer(matching_lines(input).length)
