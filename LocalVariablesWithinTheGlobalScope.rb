#Parte 1...........................................................................................
local_variable =  "this is my local var"
def return_my_local_var
	#local_variable
end
puts local_variable
puts return_my_local_var
=begin
Resultado:	
	Mensaje de Error: in `return_my_local_var': undefined local variable or method `local_variable' for main
=end

#Parte 1.2...........................................................................................
local_variable =  "this is my local var"
def return_my_local_var
	local_variable = "this is my local var Inside Method"
end
puts local_variable
puts return_my_local_var

=begin
this is my local var
this is my local var Inside Method
[Finished in 0.6s]
=end

#Parte 2...........................................................................................
class DummyClass
	local_variable =  "this is my local var"
	def return_my_local_var
		#local_variable
	end
end
a = DummyClass.new
puts a.return_my_local_var
=begin
Resultado:	
`return_my_local_var': undefined local variable or method `local_variable' for #<DummyClass	
=end

#Parte 2.1...........................................................................................
class DummyClass
	def initialize
		local_variable =  "this is my local var"
	end
	def return_my_local_var
		#local_variable
	end
end
a = DummyClass.new
puts a.return_my_local_var
=begin
Resultado:	
`return_my_local_var': undefined local variable or method `local_variable' for #<DummyClass	
=end

#Parte 2.2...........................................................................................
class DummyClass
	def initialize
		@local_variable =  "this is my local var"
	end
	def return_my_local_var
		@local_variable
	end
end
a = DummyClass.new
puts a.return_my_local_var
=begin
Resultado:	
this is my local var
Nota: Las variables de instancia sirven para contener datos que se pueden utilizar durante toda la clase.
=end

#Parte 3...........................................................................................
class DummyClass2
	@@class_variable = "This is a class variable"
	
	# Este es un getter
    def instance_var
      @@class_variable
    end

    # Este es un setter
    def instance_var=(value)
      @@class_variable = value
    end
end
dummy_1 = DummyClass2.new
dummy_2 = DummyClass2.new
puts dummy_1.instance_var
puts dummy_2.instance_var
dummy_1.instance_var = ("New value for the class variable")
puts dummy_1.instance_var
puts dummy_2.instance_var
=begin
Resultado:	
New value for the class variable
New value for the class variable
[Finished in 0.6s]
=end

#PArte 4...........................................................................................
$global_var = "This is a global variable"
CONSTANT = 3.1416 

def global_var
   $global_var
end

def global_var=(value)
   $global_var = value
end

puts global_var
global_var = "Prueba"
puts global_var
=begin
This is a global variable
Prueba
[Finished in 0.5s]
=end