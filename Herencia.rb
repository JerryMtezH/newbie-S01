class Vehicle
  attr_reader :number_of_wheels, :color, :age, :has_motor, :tank_size, :refuel, :number_of_gears
  def initialize
    @age += 2
  end
  def what_am_i?
    self.class
  end
  def age!
    @age
  end
end

class Motorized < Vehicle
  def initialize
    @age += 2
    super
  end
end

class Motorbike < Motorized
  def initialize
    @age = 2
    super
  end
end

class Car < Motorized
  def initialize
    @age = 3
    super
  end
end

class Bicycle < Vehicle
  attr_accessor :age
  @age = 0
  def initialize(age)
    @age = age
  end
end

class Skateboard < Vehicle
  def initialize
    @age = 1
    super
  end
end

moto = Motorbike.new
car = Car.new
bike = Bicycle.new(8)
skateboard = Skateboard.new

vehicles = [moto, car, bike, skateboard]


vehicles.each do |vehicle|
  vehicle.age!
  puts "#{vehicle.what_am_i?} responds to:"
  puts "\tNumber of wheels: #{vehicle.respond_to?(:number_of_wheels) == true}"
  puts "\tColor: #{vehicle.respond_to?(:color) == true}"
  puts "\tAge!: #{vehicle.respond_to?(:age!) == true}"
  puts "\tHas motor: #{vehicle.respond_to?(:has_motor) == true}"
  puts "\tTank size: #{vehicle.respond_to?(:tank_size) == true}"
  puts "\tRefuel: #{vehicle.respond_to?(:refuel) == true}"
  puts "\tNumber of gears: #{vehicle.respond_to?(:number_of_gears) == true}"
  puts "\tAge: #{vehicle.age}"
  puts "\n\n"
end