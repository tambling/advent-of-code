# frozen_string_literal: true

require "minitest"
require "byebug"

module SimpleTest
  extend ::Minitest::Assertions

  class << self
    attr_accessor :assertions
  end

  self.assertions = 0
end

@file = __FILE__

def setup_inputs(file)
  @file = file
end

def day_directory
  File.dirname(@file)
end

def test_input
  File.read(File.join(day_directory, "/test_input.txt")).split("\n")
end

def input
  File.read(File.join(day_directory, "./input.txt")).split("\n")
end

def present_answer(answer)
  puts "The answer is #{answer}"
end
