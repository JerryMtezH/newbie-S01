class People
	
	#Método initialize sirve para arrancar o construir cada objeto
	def initialize(people)
		@name = people
	end

	#Comportamiento
	def speak
		"#{@name} is talking to you..."
	end
end

#test
people_1 = People.new("Rodrigo")
people_2 = People.new("Carlos")
people_3 = People.new("Rodrigo")

p people_1.speak == "Rodrigo is talking to you..."
p people_2.speak == "Carlos is talking to you..."
p people_3.speak == "Rodrigo is talking to you..."