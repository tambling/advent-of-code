# frozen_string_literal: true

require_relative "../../helper"

setup_inputs(__FILE__)

def activated_after_cycles(initial_state, rounds: 6)
  state = [initial_state.map { |row| row.split("") }]
  state = pad(state) if needs_padding?(state)

  1.upto(rounds) do |i|
    previous_state = Marshal.load(Marshal.dump(state))
    state  = []

    (0...previous_state.length).each do |z|
      (0...previous_state.first.length).each do |y|
        (0...previous_state.first.first.length).each do |x|
          new_state = state_given_neighbors(z, y, x, previous_state)
          state[z] ||= []
          state[z][y] ||= []
          state[z][y][x] = new_state || "."
        end
      end
    end

    pad(state) if needs_padding?(state)
    print_legibly(state)
  end

  state.flatten.count("#")
end

def pad(state)
  height = state.first.length
  width = state.first.first.length

  state.each do |slice|
    slice.each do |row|
      row.unshift(".")
      row.push(".")
    end
    slice.unshift(["."] * (width + 2))
    slice.push(["."] * (width + 2))
  end
  state.unshift([["."] * ( width + 2 )] * ( height + 2))
  state.push([["."] * ( width + 2)] * ( height + 2))
  state
end

def needs_padding?(state)
  state.first.flatten.include?("#") ||
    state.last.flatten.include?("#") ||
    state.any? do |slice|
      slice.first.include?("#") ||
        slice.last.include?("#") ||
        slice.any? do |row|
          row.first == "#" || row.last == "#"
        end
    end
end

def state_given_neighbors(z, y, x, state)
  neighbors = [-1, 0, 1].repeated_permutation(3).to_a.map do |coordinates|
    new_z = z + coordinates[0]
    new_y = y + coordinates[1]
    new_x = x + coordinates[2]

    extant = !coordinates.all? {|coord| coord.zero? } &&
      new_z.between?(0, state.length - 1) &&
      new_y.between?(0, state.first.length - 1) &&
      new_x.between?(0, state.first.first.length - 1)

    if extant && (extant_neighbor = state[new_z][new_y][new_x])
      extant_neighbor
    end
  end


  if (state.dig(z, y, x) == "#")
    neighbors.count("#").between?(2, 3) ? "#" : "."
  else
    neighbors.count("#") == 3 ? "#" : "."
  end
end

def print_legibly(state)
  state.each do |slice|
    puts slice.map(&:join).join("\n")
    puts
  end
  puts "********"
  puts
end

# SimpleTest.assert_equal(112, activated_after_cycles(test_input))
# present_answer(activated_after_cycles(input))

def hyper_activated_after_cycles(initial_state, rounds: 6)
  state = [[initial_state.map { |row| row.split("") }]]
  state = hyper_pad(state) if hyper_needs_padding?(state)

  1.upto(rounds) do |i|
    previous_state = Marshal.load(Marshal.dump(state))
    state = []

    (0...previous_state.length).each do |w|
      (0...previous_state.first.length).each do |z|
        (0...previous_state.first.first.length).each do |y|
          (0...previous_state.first.first.first.length).each do |x|
            new_state = hyper_state_given_neighbors(w, z, y, x, previous_state)
            state[w] ||= []
            state[w][z] ||= []
            state[w][z][y] ||= []
            state[w][z][y][x] = new_state || "."
          end
        end
      end
    end

    hyper_print_legibly(state)
    state = hyper_pad(state) if hyper_needs_padding?(state)
  end

  state.flatten.count("#")
end

def hyper_pad(state)
  depth = state.first.length
  height = state.first.first.length
  width = state.first.first.first.length

  state.each do |cube|
    cube.each do |slice|
      slice.each do |row|
        row.unshift(".")
        row.push(".")
      end
      slice.unshift(["."] * (width + 2))
      slice.push(["."] * (width + 2))
    end
    cube.unshift([["."] * ( width + 2 )] * ( height + 2))
    cube.push([["."] * ( width + 2)] * ( height + 2))
  end
  state.unshift([[["."] * ( width + 2 )] * ( height + 2)] * (depth + 2))
  state.push([[["."] * ( width + 2 )] * ( height + 2)] * (depth + 2))

  state
end


def hyper_needs_padding?(state)
  state.first.flatten.include?("#") ||
    state.last.flatten.include?("#") ||
    state.any? do |cube|
      cube.first.flatten.include?("#") ||
        cube.last.flatten.include?("#") ||
        cube.any? do |slice|
          slice.first.include?("#") ||
            slice.last.include?("#") ||
            slice.any? do |row|
              row.first == "#" || row.last == "#"
            end
        end
    end
end

def hyper_state_given_neighbors(w, z, y, x, state)
  neighbors = [-1, 0, 1].repeated_permutation(4).to_a.map do |coordinates|
    new_w = w + coordinates[0]
    new_z = z + coordinates[1]
    new_y = y + coordinates[2]
    new_x = x + coordinates[3]

    extant = !coordinates.all? {|coord| coord.zero? } &&
      new_w.between?(0, state.length - 1) &&
      new_z.between?(0, state.first.length - 1) &&
      new_y.between?(0, state.first.first.length - 1) &&
      new_x.between?(0, state.first.first.first.length - 1)

    if extant && (extant_neighbor = state[new_w][new_z][new_y][new_x])
      extant_neighbor
    end
  end

  if (state.dig(w, z, y, x) == "#")
    neighbors.count("#").between?(2, 3) ? "#" : "."
  else
    neighbors.count("#") == 3 ? "#" : "."
  end
end

def hyper_print_legibly(state)
  state.each_with_index do |cube, w|
    cube.each_with_index do |slice, z|
      puts "w=#{w} z=#{z}"
      puts slice.map(&:join).join("\n")
      puts
    end
  end
  puts "********"
  puts
end


SimpleTest.assert_equal(848, hyper_activated_after_cycles(test_input, rounds: 6))
present_answer(hyper_activated_after_cycles(input))
