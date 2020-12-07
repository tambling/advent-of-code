# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

CONTAINER_REGEX = /(\w+ \w+) bags contain/.freeze
CONTENTS_REGEX = /(\d+) (\w+ \w+) bag/.freeze

class Bag
  attr_reader :containers, :containees, :name

  def initialize(name)
    @name = name
    @containers = []
    @containees = []
  end

  def add_containee(bag, count: 1)
    count.times do
      containees << bag
    end
    bag.containers << self
  end

  def contains?(bag)
    containees.uniq.include?(bag) || containees.uniq.any? { |containee| containee.contains?(bag) }
  end

  def containees_total
    containees.length + containees.map(&:containees_total).sum
  end
end

def hydrate_bags(bags)
  all_bags = {}
  bags.each do |bag|
    name = CONTAINER_REGEX.match(bag)[1]
    all_bags[name] = Bag.new(name)
  end

  bags.each do |bag|
    containing_bag_name = CONTAINER_REGEX.match(bag)[1]
    containing_bag = all_bags[containing_bag_name]

    contained_bags = bag.scan(CONTENTS_REGEX)
    contained_bags.each do |contained_bag|
      name = contained_bag.last
      count = contained_bag.first.to_i
      containing_bag.add_containee(all_bags[name], count: count)
    end
  end

  all_bags
end

all_bags = hydrate_bags(input)
shiny_gold = all_bags["shiny gold"]

first_answer = all_bags.values.count { |bag| bag.contains?(shiny_gold) }
present_answer(first_answer)

second_answer = shiny_gold.containees_total
present_answer(second_answer)
