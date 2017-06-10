class Cat
  
  CAT_YEARS = 7
  
  def initialize(age)
  	@age = age
  	p "Paso 1. (Se crea el objeto y ejecuta initialize) - cat: #{self} - @age: #{@age}"
  end
  
  def es_mayor_que?(cat)
    age > age
  end

  protected

  def age
  	p "Paso 3. ('protected' Dentro del Metodo age invocado por 'es_mayor_que?' con el primer parametro): cat: #{self} - @age: #{@age}"
  	p "Paso 3. (Resultado: #{(@age * CAT_YEARS)})"
  	(@age * CAT_YEARS)
  end

  private

  def age
  	p "Paso 3. ('private' Dentro del Metodo age invocado por 'es_mayor_que?' con el primer parametro): cat: #{self} - @age: #{@age}"
  	p "Paso 3. (Resultado: #{(@age * CAT_YEARS)})"
  	(@age * CAT_YEARS)
  end

end
#test
katty = Cat.new(2)
peto = Cat.new(4)
p "Paso 2. (Regresa el control fuera de la clase)"
p katty.es_mayor_que?(peto) == false
#=>true