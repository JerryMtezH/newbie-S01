class Computer
	attr_accessor :color
	attr_reader :processor
	
	def initialize(processor)
		@processor = processor
	end
end	
	
#test
mac = Computer.new("Intel")
p mac.processor
#=>"Intel"
mac.processor = "AMD"
#=>...undefined method `processor='...
p mac.processor