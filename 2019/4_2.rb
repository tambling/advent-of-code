require_relative './aoc_helper'
def valid_password? password
  password = password.split('')
  return false unless password.length == 6

  substring_lengths = Hash.new { 1 }

  password.each_with_index do |digit, i|
    if i + 1 < password.length && digit == password[i + 1]
      substring_lengths[digit] += 1
    end
  end

  return false unless substring_lengths.values.include?(2)

  increasing = true

  password.each_with_index do |digit, i|
    if i + 1 < password.length
      increasing = false if digit.to_i > password[i + 1].to_i
    end
  end

  return increasing
end

assert(valid_password?('112233'))
assert(!valid_password?('123444'))
assert(valid_password?('111122'))

valid_passwords = 0

(231832..767346).each do |password|
  valid_passwords += 1 if valid_password?(password.to_s)
end

present_answer(valid_passwords)
