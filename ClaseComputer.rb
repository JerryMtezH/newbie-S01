class Computer(procesador)
	attr_accessor :color
	attr_reader :procesador
	def initialize
		@procesador = procesador
	end
end	
	
#test
mac = Computer.new
mac.color = "Platinum"
p mac.color
#=>"Platinum"
