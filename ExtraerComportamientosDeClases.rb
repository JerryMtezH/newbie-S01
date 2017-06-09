class Animal
  def speak
    "Hello!"
  end
end

class Dog < Animal
end

class Cat < Animal
end

drako = Dog.new
peto = Cat.new
p drako.speak == "Hello!"          
p peto.speak == "Hello!"           