# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)


def valid_passports_count(passport_data, strict: false)
  count = 0
  passports = passport_data.split("\n\n")
  passports.each do |passport|
    validator = PassportValidator.new(passport)

    if strict
      count += 1 if validator.strict_valid?
    else
      count += 1 if validator.valid?
    end
  end

  count
end

class PassportValidator
  REQUIRED_CREDENTIALS = %w(
  byr
  iyr
  eyr
  hgt
  hcl
  ecl
  pid
  ).freeze

  PASSPORT_REGEX = /(.{3}):/.freeze

  def initialize(passport)
    @passport = passport + "\n"
  end

  def valid?
    REQUIRED_CREDENTIALS - @passport.scan(PASSPORT_REGEX).flatten == []
  end

  def strict_valid?
    byr_valid? &&
      iyr_valid? &&
      eyr_valid? &&
      hgt_valid? &&
      hcl_valid? &&
      ecl_valid? &&
      pid_valid?
  end

  def byr_valid?
    byr_regex = /byr:(\d{4})\s/
    birth_year = @passport.scan(byr_regex).flatten.first
    (1920..2002).cover?(birth_year.to_i)
  end

  def iyr_valid?
    iyr_regex = /iyr:(\d{4})\s/
    issue_year = @passport.scan(iyr_regex).flatten.first
    (2010..2020).cover?(issue_year.to_i)
  end

  def eyr_valid?
    eyr_regex = /eyr:(\d{4})\s/
    expiration_year = @passport.scan(eyr_regex).flatten.first
    (2020..2030).cover?(expiration_year.to_i)
  end

  def hgt_valid?
    hgt_regex = /hgt:(?<number>\d+)(?<unit>cm|in)\s/
    height_match = @passport.match(hgt_regex)

    return nil unless height_match

    height = height_match[:number].to_i
    if height_match[:unit] == "cm"
      (150..193).cover?(height)
    else
      (59..76).cover?(height)
    end
  end

  def hcl_valid?
    hcl_regex = /hcl:#[a-f0-9]{6}\s/
    @passport.match(hcl_regex)
  end

  def ecl_valid?
    ecl_regex = /ecl:amb|blu|brn|gry|grn|hzl|oth\s/
    @passport.match(ecl_regex)
  end

  def pid_valid?
    pid_regex = /pid:(\d{9})\s/
    match = @passport.scan(pid_regex).flatten.first

    match.to_i.positive?
  end
end


SimpleTest.assert_equal(2, valid_passports_count(test_input(raw: true)))

present_answer(valid_passports_count(input(raw: true)))

strict_test_fixture = <<-STRICT
 hcl:dab227 iyr:2012
  110 ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277
STRICT

SimpleTest.assert(!PassportValidator.new(strict_test_fixture).strict_valid?)

present_answer(valid_passports_count(input(raw: true), strict: true))
