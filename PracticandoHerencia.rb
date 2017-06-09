class Animal
	attr_reader :kind_characteristics
	@kind_characteristics = []
	def initialize
		@kind_characteristics = ["It has a cell nucleus where its genome resides", "It has more than one cell", "They are fed by ingestion", "They consume oxygen", "They have radial symmetry and bilateral symmetry"]
	end
	def breathe
		"This #{self.class} is breathing... "
	end
	def sleep
		"This #{self.class} is Sleeping... "
	end
	def eat
		"This #{self.class} is Eating... "
	end
	def see
		"This #{self.class} is Seeing... "
	end
	def move
		"This #{self.class} is Moving... "
	end
end

class Reptile < Animal
	attr_reader :msg, :subkind_characteristics
	@subkind_characteristics = []
	def initialize
		@subkind_characteristics = ["They are terrestrial vertebrates, with their bodies generally covered with scales", "They have short or lateral limbs or they lack them", "They have skin covered with scales, shields or plaques corneas", "They are cold-blooded and spend the winter lethargic"," They have pulmonary and cutaneous breathing"," They reproduce by eggs"]
	end
	def warm_blooded?
		false
	end
	def has_wings?
  		false
	end
	def can_swim?
		false
	end
	def has_scales?
  		true
	end
end

class Mammal < Animal
	attr_reader :msg, :subkind_characteristics
	@subkind_characteristics = []
	def initialize
		@subkind_characteristics = ["All mammals are warm blooded","Most young are born alive","They have hair or fur on their bodies","Every mammal is a vertebrate","All mammals have lungs to breathe air","Mammals feed milk to their babies."]
		super
	end
	def warm_blooded?
		true
	end
	def has_wings?
  		false
	end
	def can_swim?
		false
	end
	def has_scales?
  		false
	end
end

class Bird < Animal
	attr_reader :msg, :subkind_characteristics
	@subkind_characteristics = []
	def initialize
		@subkind_characteristics = ["All birds are warm blooded","Have wings and feathers"]
	end
	def has_wings?
  		true
	end
	def warm_blooded?
		true
	end
	def flying
		"Flying..."
  	end
  	def can_swim?
  		false
  	end	
  	def has_scales?
  		false
	end
end

class Dog < Mammal
	def initialize
		super
	end
	def move 
		super + "by walking"
	end	
end

class Turtle < Reptile
	def initialize
		super
	end
	def can_swim?
  		true
	end
	def swim
		"This #{self.class} is Swiming..."
	end
	def move 
		super + "by walking and swiming"
	end	
end

class Macaw < Bird
	def initialize
		super
	end
	def move 
		super + "by jumping and flying"
	end	
end

class Fish < Animal
	def initialize
		super
	end
	def can_swim?
  		true
	end
	def swim
		"This #{self.class} is Swiming..."
	end
	def move 
		super + "by swiming"
	end
	def has_scales?
  		true
	end	
end

class Dolphin < Mammal
	def initialize
		super
	end
	def can_swim?
  		true
	end
	def swim
		"This #{self.class} is Swiming..."
	end
	def move 
		super + "by swiming"
	end	
end

class Cat < Mammal
	def initialize
		super
	end
	def meow
		"Miaaaauuuu!!!!"
	end
end

class Whale < Mammal
	def initialize
		super
	end
	def can_swim?
  		true
	end
	def swim
		"This #{self.class} is Swiming..."
	end
	def move 
		super + "by swiming"
	end	
end

class Snake < Reptile
	def initialize
		super
	end
	def move 
		super + "by crawling"
	end	
end

class Penwin < Bird
	def initialize
		super
	end
	def can_swim?
  		true
	end
	def swim
		"This #{self.class} is Swiming..."
	end
	def move 
		super + "by walking and swiming"
	end	
end

#test
#Aquí deben ir las pruebas correspondientes
kitty = Cat.new
willy = Whale.new
sam = Turtle.new
p kitty.eat == "This Cat is Eating... "
p kitty.warm_blooded? == true
p kitty.has_wings? == false
p kitty.can_swim? == false
p kitty.move == "This Cat is Moving... "
p kitty.meow == "Miaaaauuuu!!!!"
p willy.warm_blooded? == true
p willy.has_wings? == false
p willy.can_swim? == true
p willy.has_scales? == false
p willy.move == "This Whale is Moving... by swiming"
p willy.kind_characteristics == ["It has a cell nucleus where its genome resides", "It has more than one cell", "They are fed by ingestion", "They consume oxygen", "They have radial symmetry and bilateral symmetry"]
p willy.subkind_characteristics == ["All mammals are warm blooded", "Most young are born alive", "They have hair or fur on their bodies", "Every mammal is a vertebrate", "All mammals have lungs to breathe air", "Mammals feed milk to their babies."]
p sam.eat == "This Turtle is Eating... "
p sam.sleep == "This Turtle is Sleeping... "
p sam.warm_blooded? == false
p sam.has_wings? == false
p sam.can_swim? == true
p sam.move == "This Turtle is Moving... by walking and swiming"
p sam.swim == "This Turtle is Swiming..."