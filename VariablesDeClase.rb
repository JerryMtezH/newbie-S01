class Vehicle
	@@count_vehicles = 0
	def initialize
		@@count_vehicles += 1
	end
	def self.number_of_vehicles
		 "This Superclass has created #{@@count_vehicles} vehicles"
	end
end

class Car < Vehicle
	def initialize
		super
	end	
end

class Bus < Vehicle
	def initialize
		super
	end	
end

#test
car_1 = Car.new
car_2 = Car.new
bus_1 = Bus.new

p Car.number_of_vehicles == "This Superclass has created 3 vehicles"
a= Time.new

# => true