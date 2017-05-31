class RaceCar
  
  #variables de clase 
  @@number_of_cars = 0
  @@cars = []
  @@cars_running = []
  @@cars_stopped = []
  @@car_id = 0

  #Método initialize sirve para arrancar o construir cada objeto
  def initialize(brand, model)
    #variable de instancia 1
    @brand = brand
    #variable de instancia 2
    @model = model
    #variable de clase 
    @@number_of_cars += 1
    @@car_id += 1
    @@cars << {car_id: @@car_id, brand: @brand, model: @model}

  end

  #método de clase
  def self.number_of_cars
    @@number_of_cars
  end

  #método de clase
  def self.cars
    @@cars
  end

  #método de clase
  def self.incrementar_velocidad
     puts "Incrementando velocidad"
  end

  #comportamiento 1
  def acelerar
    puts "Arrancando #{@brand}, #{@model}"
  end

  #comportamiento 2
  def frenar
    puts "Frenando #{@brand}, #{@model}"
  end

end

#instancias de RaceCar
puts ""
puts "Añadiendo carros...."
speedy = RaceCar.new("toyota", "1987")
bolt = RaceCar.new("mercedez", "1997")

puts ""
puts "Carros Disponibles #{RaceCar.number_of_cars}:"
p RaceCar.cars

#método de instancia 'acelerar'
puts ""
puts "Acelerando...."
speedy.acelerar
bolt.acelerar

#método de instancia 'frenar'
puts ""
puts "Frenando...."
speedy.frenar
bolt.frenar

#método de clase
puts ""
puts "Incrementando la Velocidad de los Carros Activos...."
RaceCar.incrementar_velocidad

puts ""
puts "Añadiendo mas carros al Garage...."
race_car1 = RaceCar.new("bmw", "2017")

puts ""
puts "Carros Disponibles #{RaceCar.number_of_cars}:"
p RaceCar.cars

puts ""
puts "Añadiendo mas carros al Garage...."
race_car2 = RaceCar.new("audi", "2017")
race_car3 = RaceCar.new("ferrari", "2017")
race_car4 = RaceCar.new("lamborgini", "2017")

puts ""
puts "Carros Disponibles #{RaceCar.number_of_cars}:"
p RaceCar.cars

puts ""
puts "Acelerando...."
race_car1.acelerar
race_car2.acelerar

puts ""
puts "Frenando...."
race_car1.frenar