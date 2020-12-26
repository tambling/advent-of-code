# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def passphrase_valid?(passphrase, allow_anagrams: true)
  passphrase_parts = passphrase.split

  if allow_anagrams
    passphrase_parts == passphrase_parts.uniq
  else
    passphrase_part_characters = passphrase_parts.map { |part| part.split("") }
    passphrase_part_characters.map(&:sort!)
    passphrase_part_characters == passphrase_part_characters.uniq
  end
end

SimpleTest.assert(passphrase_valid?("aa bb cc dd ee"))
SimpleTest.assert(passphrase_valid?("aa bb cc dd ee"))
SimpleTest.assert(passphrase_valid?("aa bb cc dd aaa"))

answer = input.count { |passphrase| passphrase_valid?(passphrase) }
present_answer(answer)


SimpleTest.assert(passphrase_valid?("abcde fghij", allow_anagrams: false))
SimpleTest.assert(!passphrase_valid?("abcde xyz ecdab", allow_anagrams: false))
SimpleTest.assert(passphrase_valid?("a ab abc abd abf abj", allow_anagrams: false))
SimpleTest.assert(passphrase_valid?("iiii oiii ooii oooi oooo", allow_anagrams: false))
SimpleTest.assert(!passphrase_valid?("oiii ioii iioi iiio", allow_anagrams: false))

second_answer = input.count { |passphrase| passphrase_valid?(passphrase, allow_anagrams: false) }
present_answer(second_answer)
