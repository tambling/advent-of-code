# frozen_string_literal: true

require "test/unit"
require "byebug"

include Test::Unit::Assertions

def inputs(blob = File.read(ARGV[0]))
  blob.split("\n")
end

def present_answer(answer)
  puts "The answer is #{answer}"
end
