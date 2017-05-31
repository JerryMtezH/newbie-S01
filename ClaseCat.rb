class Cat
	@@cats = []
	def initialize(cat)
		@@cats << cat
	end

	#método de clase
	def self.meow
		"Miau... Miau..."
	end

	#Comportamiento
	def run(*meters)
		meters.count == 1 ? @meters += meters[0] : @meters = 0	
		"Corriendo #{@meters} mts..."
	end

	#Comportamiento
	def jump
		"Saltando..."
	end
end

#test

cat_1 = Cat.new("tomas")
cat_2 = Cat.new("botas")
cat_3 = Cat.new("catty")
cat_4 = Cat.new("pirruri")
cat_5 = Cat.new("negro")

p cat_1.jump == "Saltando..."
p cat_5.jump == "Saltando..."
p Cat.meow == "Miau... Miau..."
p cat_3.run == "Corriendo 0 mts..."
p cat_3.run(20) == "Corriendo 20 mts..."
p cat_3.run(10) == "Corriendo 30 mts..."
p cat_3.run(10) == "Corriendo 40 mts..."