# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

PASSWORD_ROW_REGEX = /(\d+)-(\d+) ([a-z]): ([a-z]+)/.freeze

def old_valid_passwords_count(password_rows)
  password_rows.count do |password_row|
    _, min, max, char, password = PASSWORD_ROW_REGEX.match(password_row).to_a
    min.to_i <= password.count(char) && password.count(char) <= max.to_i
  end
end

def new_valid_passwords_count(password_rows)
  password_rows.count do |password_row|
    _, n, m, char, password = PASSWORD_ROW_REGEX.match(password_row).to_a

    first_char = password[n.to_i - 1]
    second_char = password[m.to_i - 1]

    [first_char, second_char].count(char) == 1
  end
end

SimpleTest.assert_equal(old_valid_passwords_count(test_input), 2)
SimpleTest.assert_equal(new_valid_passwords_count(test_input), 1)
