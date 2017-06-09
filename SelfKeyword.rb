puts "self es igual a: #{self}"
=begin
Resultado:
self es igual a: main
[Finished in 0.6s]
=end
class DummyClass
  puts "Esto esta corriendo cuando se define la clase"
  puts "En este contexto self es igual a: #{self}"
end
=begin
Resultado:
Esto esta corriendo cuando se define la clase
En este contexto self es igual a: DummyClass
[Finished in 0.6s]
=end
class DummyClass
    def intance_method
        puts "Dentro de un método de instancia"
        puts "En este contexto self es igual a: #{self}"
    end
end
dummy_class = DummyClass.new()
puts dummy_class.intance_method
=begin
Resultado:
Dentro de un método de instancia
En este contexto self es igual a: #<DummyClass:0x2b16550>
=end

class DummyClass1

    def self.class_method
        puts "Dentro de un método de clase"
        puts "En este contexto self es igual a: #{self}"
    end
end

dummy_class = DummyClass1.new()
puts DummyClass1.class_method  
=begin
Resultado:
Dentro de un método de clase
En este contexto self es igual a: DummyClass1
=end 

#Notas:
# self indica el objeto que se está usando en ese instante, partiendo de la base
# de que en rubi todo es un objeto, entonces nos da el nombre main como primero
# o el nombre de la clase en la que se ejecuta. "main" esta relacionado al 
# "nivel superior", el cual se refiere al lo que esta fuera de las clases