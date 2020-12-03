require_relative "../aoc_helper"

test_fixture = <<~FIXTURE
  1-3 a: abcde
  1-3 b: cdefg
  2-9 c: ccccccccc
FIXTURE

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

assert_equal(old_valid_passwords_count(inputs(test_fixture)), 2)
assert_equal(new_valid_passwords_count(inputs(test_fixture)), 1)

present_answer(new_valid_passwords_count(inputs))
