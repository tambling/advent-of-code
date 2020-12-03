require_relative './aoc_helper'
def valid_password? password
  password = password.split('')
  return false unless password.length == 6

  repeating_digit = false

  password.each_with_index do |digit, i|
    if i + 1 < password.length
      repeating_digit = true if digit == password[i+1]
    end
  end

  return false unless repeating_digit

  increasing = true

  password.each_with_index do |digit, i|
    if i + 1 < password.length
      increasing = false if digit.to_i > password[i + 1].to_i
    end
  end

  return increasing
end

assert(valid_password?('111111'))
assert(!valid_password?('223450'))
assert(!valid_password?('123789'))

valid_passwords = 0

(231832..767346).each do |password|
  valid_passwords += 1 if valid_password?(password.to_s)
end

present_answer(valid_passwords)
