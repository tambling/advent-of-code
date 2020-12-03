require_relative './aoc_helper'

class CompoundSystem
  attr_reader :compounds

  def initialize(formulas)
    @compounds = {}
    parse_formulas(formulas)
  end

  def ore_for_fuel
    fuel.create(1)
    ore.given
  end

  def set_compound(name, compound)
    @compounds[name] = compound
  end

  def get_compound(name)
    @compounds[name]
  end

  def reset_all
    @compounds.values.each(&:reset)
  end

  def fuel_given_ore ore_amount
    fuel_amount = (0..).bsearch do |i|
      reset_all
      fuel.create(i)
      ore.given > ore_amount
    end

    fuel_amount - 1
  end


  private
  def parse_formulas formulas
    formulas = formulas.split("\n") if formulas.is_a?(String)
    formulas.each do |line|
      inputs, output = line.split('=>').map(&:strip)
      inputs = inputs.split(',').map(&:strip)
      Compound.new(inputs, output, self)
    end

    Compound.new([], '1 ORE', self)
  end

  def ore
    @compounds['ORE']
  end

  def fuel
    @compounds['FUEL']
  end
end


class Compound
  REGEX = /(?<quantity>\d+) (?<compound>.+)/
  attr_reader :given, :stock, :name
  def initialize(inputs, output, system)
    @system = system
    @inputs = {}
    parse_inputs(inputs)
    @name = nil
    @yield = 0
    parse_output(output)
    @given = 0
    @stock = 0
  end

  def give(quantity = 1)
    if !ore?
      needed = quantity - @stock
      if needed > 0
        create((needed.to_f / @yield).ceil)
      end

      @stock -= quantity
    end

    @given += quantity
  end

  def create(multiple)
    @inputs.each do |input, quantity|
      input_compound = @system.get_compound(input)

      input_compound.give(quantity * multiple)
    end

    @stock += @yield * multiple
  end

  def ore?
    @name == 'ORE'
  end

  def reset
    @given = 0
    @stock = 0
  end

  def parse_inputs inputs
    inputs.each do |input|
      compound = input.match(REGEX)[:compound]
      quantity = input.match(REGEX)[:quantity].to_i
      @inputs[compound] = quantity
    end
  end

  def parse_output output
    @yield = output.match(REGEX)[:quantity].to_i
    @name = output.match(REGEX)[:compound]
    @system.set_compound(@name, self)
  end
end


first_fixture = <<-FORMULA
157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
FORMULA

TRILLION = 1000000000000
first_system = CompoundSystem.new(first_fixture)
fuel = first_system.get_compound('FUEL')
assert_equal 82892753, first_system.fuel_given_ore(TRILLION)

second_fixture = <<-FORMULA
2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF
FORMULA

second_system = CompoundSystem.new(second_fixture)
assert_equal 5586022, second_system.fuel_given_ore(TRILLION)

final_system = CompoundSystem.new(inputs)
present_answer(final_system.fuel_given_ore(TRILLION))
