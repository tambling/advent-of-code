require_relative './aoc_helper'

class PlanetarySystem
  attr_reader :planets
  def initialize planets = []
    @planets = planets
    @states = { x: {}, y: {}, z: {}} 
    @steps = 0
  end

  def step(n = 1)
    n.times do 
      update_velocities
      update_positions
      @steps += 1
    end
  end

  def potential_energy
    @planets.map(&:potential_energy).sum
  end

  def kinetic_energy
    @planets.map(&:kinetic_energy).sum
  end

  def total_energy
    @planets.map(&:total_energy).sum
  end

  def state_for dimension
    @planets.map {|p| p.state_for(dimension)}.join(',')
  end

  def periodicity(dimension)
    @steps = 0

    while !@states[dimension][state_for(dimension)]
      @states[dimension][state_for(dimension)] ||= []
      @states[dimension][state_for(dimension)].push(@steps)
      step
    end

    return @steps - @states[dimension][state_for(dimension)].first
  end

  private

  def update_velocities
    @planets.each do |planet|
      planet.update_velocity(@planets.reject { |p| p == planet })
    end
  end

  def update_positions
    @planets.each(&:update_position)
  end

  def states
    @planets.map(&:to_s).join(';')
  end

  def record_states
    @states[states] = true
  end
end

class Planet
  attr_reader :position

  def initialize(x:, y:, z:)
    @position = { x: x.to_i, y: y.to_i, z: z.to_i }
    @velocity = { x: 0, y: 0, z: 0 }
  end

  def dimensions
    @position.keys
  end

  def update_velocity other_planets

    dimensions.each do |dimension|
      @velocity[dimension] += other_planets.select { |p| p.position[dimension] > self.position[dimension]}.length
      @velocity[dimension] -= other_planets.select { |p| p.position[dimension] < self.position[dimension]}.length
    end
  end

  def update_position
    dimensions.each do |dimension|
      @position[dimension] += @velocity[dimension]
    end
  end

  def potential_energy
    @position.values.map(&:abs).sum
  end

  def kinetic_energy
    @velocity.values.map(&:abs).sum
  end

  def total_energy
    potential_energy * kinetic_energy
  end

  def to_s
    "#{@position.values.join}#{@velocity.values.join}"
  end
  def state_for dimension
    "#{@position[dimension]}:#{@velocity[dimension]}"

  end
end

POSITION_REGEX = /\<x=(?<x>-?\d+), y=(?<y>-?\d+), z=(?<z>-?\d+)\>/

# first_fixture = "<x=-1, y=0, z=2>
# <x=2, y=-10, z=-7>
# <x=4, y=-8, z=8>
# <x=3, y=5, z=-1>"

# fixture_planets = first_fixture.split("\n").map do |line|
#   coordinates = line.match(POSITION_REGEX).named_captures
#   Planet.new(x: coordinates['x'], y: coordinates['y'], z: coordinates['z'])
# end


# fixture_system = PlanetarySystem.new(fixture_planets)

# fixture_system.step(10)

# assert_equal 179, fixture_system.total_energy


planets = inputs.map do |line|
  coordinates = line.match(POSITION_REGEX).named_captures
  Planet.new(x: coordinates['x'], y: coordinates['y'], z: coordinates['z'])
end

system = PlanetarySystem.new(planets)

x_periodicity = system.periodicity(:x)
p x_periodicity

y_periodicity = system.periodicity(:y)
p y_periodicity

z_periodicity = system.periodicity(:z)
p z_periodicity
