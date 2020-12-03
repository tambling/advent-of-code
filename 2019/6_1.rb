require_relative './aoc_helper.rb'

class OrbitSystem
  def initialize(orbits)
    @planets = {}
    parse_orbits(orbits)
  end

  def all_orbits_count
    @planets.values.map(&:all_orbiters_count).reduce(&:+)
  end

  def transfers_between source_name, target_name
    source = @planets[source_name]
    target = @planets[target_name]
    transfers = 0

    mutual_orbit = source.orbit

    while !mutual_orbit.all_orbiters.include?(target)
      mutual_orbit = mutual_orbit.orbit
      transfers += 1
    end

    target_orbit = target.orbit

    while target_orbit != mutual_orbit
      target_orbit = target_orbit.orbit
      transfers += 1
    end

    return transfers
  end

  private

  def parse_orbits orbits
    orbits.each do |orbit|
      planet_names = orbit.split(')')
      planet = @planets[planet_names.first] ||= Planet.new(planet_names.first)
      satellite = @planets[planet_names.last] ||= Planet.new(planet_names.last)

      planet.add_orbiter satellite
    end
  end
end

class Planet
  attr_reader :name, :orbits, :orbit
  def initialize(name)
    @name = name
    @orbits = []
    @orbit = nil
  end

  def set_orbit planet
    @orbit = planet
  end

  def add_orbiter planet
    @orbits.push planet
    planet.set_orbit self
  end

  def direct_orbiters
    @orbits
  end

  def indirect_orbiters
    [@orbits.map(&:direct_orbiters), @orbits.map(&:indirect_orbiters)].flatten
  end

  def all_orbiters
    [direct_orbiters, indirect_orbiters].flatten
  end

  def all_orbiters_count
    direct_orbiters.length + indirect_orbiters.length
  end
end

first_fixture = %w{ COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L }

assert_equal(42, OrbitSystem.new(first_fixture).all_orbits_count)

second_fixture = %w{ COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN}

assert_equal(4, OrbitSystem.new(second_fixture).transfers_between('YOU', 'SAN'))

present_answer(OrbitSystem.new(inputs).transfers_between('YOU', 'SAN'))
