=begin

  1. Inheritance - Herencia, atributos o comportamientos que se heredan de una clase a una sub-clase
        Ej. - En la Clase "Animales": Duermen, Comen, Respiran, 
            - En la SubClase "Oviparos": Heredan el comportamiento de todos los animales, es decir;
                los animales oviparos tambien Duermen, Comen, Respiran, pero adicionalmente 
                Tienen un comportamiento o atributo especifico, nacen del huevo.
            - En la SubSubClase "Aves" que herdan el atributo "nacen de huevo", adicionalmente puden
                 tener atributos como son, tienen alas, etc. Se pueden heredar comportamientos 
                 (metodos) y/o atributos (valores dentro de variables).

            class Animal
                def respira
                end
                def duerme
                end
            end    

            class Oviparos < Animal
                def nace_de_huevo
                end    
            end    

            class Ave < Oviparo
                def tiene_alas?
                end    
            end    
 
  2. Composition - Composicion, atributos que hacen los metodos privados o protegidos, son funciones
               de la clase que son exclusivas de si misma y no tendria sentido hacerlas publicas.
               en la composicion los datos o atributos deben existir con la existencia del objeto. 
               el sexo es parte de una persona, no puede existir una persona sin que tenga sexo. Lo 
               opuesto seria la asociacion, en la asociacion un objeto puede o no ser asociado a un
               atributo, por ejemplo una persona puede o no tener hijos, o dinero, o ropa, etc. la 
               asociacion es algo que "se usa" en lugar de "se tiene" 

            Ej. 

            class Persona
                attr_accessor :sexo
                def initialize(sexo)
                    @sexo = sexo
                end   
            end    
  
  3. Encapsulation - Es la accion de ocultar la informacion del objeto que no es necesaria mostrar
                por seguridad o modularidad. 

                Modularidad. El codigo puede ser escrito y mantenido independientemente del código 
                fuente de otros objetos un objeto puede ser transferido alrededor del sistema sin 
                alterar su estado y conducta.

                Seguridad - Ocultar la información, es decir, un objeto tiene una "interfaz publica" 
                que otros objetos pueden utilizar para comunicarse con él. Pero el objeto puede 
                mantener información y métodos privados o protegidos que pueden ser cambiados en 
                cualquier tiempo sin afectar a los otros objetos que dependan de ello. 

                tres niveles (Publico - Todo mundo puede usarlo o acceder, protegido - se puede 
                usar dentro de la misma clase u otros objetos que pertenecen a la misma clase y
                privado, solamente puede ser usado dentro del mismo objeto y no puede ser usado
                desde afuera)

            Ej. De Porivado:

            class Edad
                attr_accessor :edad
                def initialize(fecha_nacimiento)
                    calcula_edad
                end   
                private
                def calcula_edad
                    edad = "Aqui se calucla la edad"
                end    
            end    

  4. Duck Typing - Hace alución al lema; "Cuando veo un ave que camina como un pato, nada como un 
                pato y suena como un pato, a esa ave yo la llamó un pato" pero en programacion orientada
                a objetos, esto se refiere a que el programador se preocupa y ocupa en los aspectos
                de los metodos, funciones o caracteristivcas que realmente se utilizaran sin ambieguedades
                por ejemplo el metodo preparar de la clase pato, puede ser muy distinta del metodo preparar
                del metodo persona, y debajo podrian tratar de utilizarse del mismo modo, pero hacen cosas
                diferentes, el programador debe preocuparse por encontrarle el sentido a la funcion y hacerla
                especifica para el proposito.

            - Ejemplo:

            class Pato
                def parpar
                    p "Cuac!"
                end    
                def plumas 
                    p "El pato tiene plumas blancas y grises."
                end    
            end        
             
            class Persona
                def parpar
                    p "La persona imita el sonido de un pato."
                end    
                def plumas
                    p "La persona toma una pluma del suelo y la muestra."
                end    
            end 
            def en_el_bosque(pato)
                pato.parpar()
                pato.plumas()
            end    
             
            def juego
                donald = Pato.new
                juan = Persona.new
                en_el_bosque(donald)
                en_el_bosque(juan)
            end    

            juego

            - Resultado:
        
            "Cuac!"
            "El pato tiene plumas blancas y grises."
            "La persona imita el sonido de un pato."
            "La persona toma una pluma del suelo y la muestra."
            [Finished in 0.6s]    

  5. The Law of Demeter (ej.) - Son estandares para que cuando se creee un objeto, este debería 
         asumir tan poco como sea posible sobre la estructura o propiedades de cualquier otro. Es decir
         objetos independientes, cada uno debe de tener sus propios propositos, sin que se asuman
         comportamientos de otros, 

         -  Cada elemento debe tener un limitado conocimiento sobre otros y solo conocer 
                lo que esta relacionadas muy de cerca con el mismo.
         -  Cada objeto debe hablar solo a sus objetos "amigos" y no hablar con extraños.
         -  Solo hablar con sus "amigos" inmediatos.

            Ej. Una clase Aguacate, no tendria absolutamente nada que ver con una clase Motor, 
            por ejemplo, pero un motor si pudiera tener una relacion cercana a combustible.

            Ej. Que falla en la ley de Demeter: 

            Class Cliente < ActiveRecord::Base
                has_one :direccion
                has_many :facturas
            end

            Class Direccion < ActiveRecord::Base
                belongs_to :cliente
            end
                
            Class Factura < ActiveRecord::Base
                belongs_to :cliente
            end

            El acceso se tendria que realizar asi lo cual viola la ley porque tiene muchos puntos y 
            Se tiene que pasar por muchos objetos para llegar al dato:

            a = factura.cliente.direccion.calle
            b = factura.cliente.direccion.municipio

            Mejorado:

            Class Cliente < ActiveRecord::Base 
            
                has_one :direccion 
                has_many :facturas 
            
                def calle 
                    self.direccion.calle 
                end 
            
                def municipio 
                    self.direccion.municipo 
                end 
            end

            Class Factura < ActiveRecord::Base 
                belongs_to :cliente 

                def cliente_calle 
                    self.cliente.calle 
                end 
                def cliente_municipio 
                    self.cliente.municipio 
                end 
            end

            Class Direccion < ActiveRecord::Base 
                belongs_to :cliente 
            end
            
            Acceso con un solo punto y se cumple con la ley de Demeter:

            a = factura.cliente_calle

            Aun Mejor delegando:

            Class Cliente < ActiveRecord::Base
                has_one :direccion
                has_many :facturas
                        
                delegate :calle, :municipio, :to => :direccion
            end

            Class Factura < ActiveRecord::Base
                belongs_to :cliente
                        
                delegate :calle, :municipio, :to => :cliente, :prefix => true
            end

            Class Direccion < ActiveRecord::Base
                belongs_to :cliente
            end

            Igual al ejemplop anterior se cumple con la ley:

            a = factura.cliente_calle

  6. Overriding Methods - Alteracion Temporal de Metodos dentro de una cubclase, es la caracteritica
            que tienen los lenguajes de programacion orientada a objetos de alterar la funcionalidad
            del mismo metodo en una subclase, esto es un comportamiento distinto cuando esta al nivel
            de subclase. 

            Ej. 
            
            class A  
              def a  
                puts 'In class A'  
              end  
            end  
              
            class B < A  
              def a  
                puts 'In class B'  
              end  
            end  
              
            b = B.new  
            b.a  

            El resultado es: 
            
            In class B
            [Finished in 0.8s]

            porque el mismo metodo existe dentro de la sub clase B el cual se ejecuta a ese nivel.
            porque el objeto fue creado a partir de B la cual hereda de A.  Mienstras que si se 
            ejecuta:

            c = A.new
            c.a

            El resultado es: 

            In class A
            [Finished in 0.6s]

    -  (and using super) - super llama al metodo de la clase padre o directa y puede o no pasar 
            parametros, esto es util cuando se requiere hacer referencia a un comportamiento del padre
            o atrubuto, tambien en el metodo constructor 'initialize' esta permitida, y esto es util
            cuando se requiere recuperar o generar los atrubutos de los objetos que se encuentran en 
            un nivel superior. 

            Ej. - En el ejemplo debajo Motorbike es una subclase de Motorized y esta es una subclase 
            de Vehicle, cuando se crea un objeto de tipo Motorbike tendria una edad (age) de 6 porqie
            en Morotbike se inicializa con 2, en Motorized se le suman 2 y en Vehicle otros 2 mas. 

            class Vehicle
              def initialize
                @age += 2
              end
            end

            class Motorized < Vehicle
              def initialize
                @age += 2
                super
              end
            end

            class Motorbike < Motorized
              def initialize
                @age = 2
                super
              end
            end

  7. Modules - Divide y Vencerás, es la capacidad de descomponer un programa complejo en pequeñas
            partes con funciones especificas, El poder tener cada parte separada nos ayuda a la 
            comprensión del código y del sistema, también a la modificación y mantenimiento.

            En ruby esta opcion permite tambien aumentar las funcionalidades de las clases, por
            ejemplo require 'Math' permitiria incluir llamadas a clases asociadas a temas de 
            calculos matematicos, o require 'Faker' permite utilizar datos generados con inform
            acion falsa para pruebas. 

            Hablando tambien de Ruby, la principal diferencia entre heredar de una clase y usar 
            un módulo, es que puedes usar más de un módulo al mismo tiempo. No se permite 
            tener más de una clase madre. Esto permite añadir numerosas funciones al código.

            Otra ventaja, es que podemos almacenar nuestros programas de forma modular: cada 
            módulo añade una característica. Esto también lo permiten las clases, pero la ventaje 
            de los módulos, es que no hace falta crear una serie de jerarquías, que podría llegar 
            a ser complicado.

            Ej. de Modulos en Ruby:

            module D  
              def initialize(nombre)  
                @nombre =nombre  
              end  
              def to_s  
                @nombre  
              end  
            end  
             
            module Debug  
              include D  
              # Los métodos que actúan como preguntas,
              # se les añade una ?
              def quien_soy?
                "#{self.class.name} (\##{self.object_id}): #{self.to_s}"
              end
            end
             
            class Gramola
              # la instrucción 'include' hace referencia a un módulo.
              # Si el módulo está en otro fichero, hay que usar 'require'
              # antes de usar el 'include'. 
              include Debug  
              # ...  
            end  
             
            class OchoPistas 
              include Debug  
              # ...  
            end  
             
            gr = Gramola.new("West End Blues")
            op = Ochopistas.new("Real Pillow")
            puts gr.quien_soy?
            puts op.quien_soy?

            El resultado es:

            Gramola (#22826820): West End Blues
            OchoPistas (#22826784): Real Pillow
            [Finished in 0.8s]
    
  8. Scope - Es el contexto que pertenece a un nombre dentro de un programa. 
            El ámbito determina en qué partes del programa una entidad puede ser usada.
            Esto nos permite tener variables con el mismo nombre en el contexto
            o ambito del programa y dentro de un metodo sin que el metodo afecte el valor
            del contexto del programa y viceversa.

            ej. En donde se ve una variable global, y con el mismo nombre una variable 
            local.

            local_variable =  "this is my local var"
            def return_my_local_var
                local_variable = "this is my local var Inside Method"
            end
            puts local_variable
            puts return_my_local_var
            puts local_variable


            Resultado:

            this is my local var
            this is my local var Inside Method
            this is my local var
            [Finished in 0.6s]

  9.  Private vs Public Methods - Los metodos publicos pueden ser accedidos desde fuera de 
            la clase, tipicamente para acceder a las funcionalidades de la clase y/o los 
            atributos mientras que los provados son utilizados por la misma clase y no se
            acceden desde fuera, estos son utilizados para realizar calculos dentro de la 
            clase normalmente para generar los atributos que se ocuparan de la clase.

            Ej. 

            class Persona
                attr_accessor :name, :born_date 
                def initialize(name,born_date)
                    @name = name
                    @born_date = born_date
                end
                def age
                    years_old
                end
                private
                def years_old
                    "#{name} is #{Time.new.year.to_i - born_date[0..3].to_i} years old."
                end
            end
            carlos = Persona.new("Carlos", "1987-08-03")
            martha = Persona.new("Martha", "1991-09-16")
            p carlos.age == "Carlos is 30 years old."
            p martha.age == "Martha is 26 years old."

            Resultado:

            true
            true
            [Finished in 1.7s]

            En este ejemplo cuando tratamos de acceder a un metodo privado:

            p carlos.years_old
            
            in `<main>': private method `years_old' called for #<Persona:0x2bf9e30 @name="Carlos", @born_date="1987-08-03"> 
            (NoMethodError) 
            [Finished in 1.7s with exit code 1]

  10. Instance vs Class methods and variables - Las variables de Clase son accedidas por todos los objetos de la misma
            clase, esto es que cualquier objeto que haya sido creado como variable de clase, sera accesible o modificable por
            todos, mientras que las variables de instancia son individuales dentro del objeto, esto es que pueden ser accedidas
            por todos los metodos dentro de la misma instancia del objeto y lo que se modifica no afecta a los otros objetos 
            creados a partir de la misma clase.

            Ej. Variable de Clase:

            #Codigo:
            class Vehicle
                attr_accesser :color
                @@count_vehicles = 0
                def initialize(color)
                    @@count_vehicles += 1
                    @color = color
                end
                def self.number_of_vehicles
                     "This Superclass has created #{@@count_vehicles} vehicles"
                end
            end

            class Car < Vehicle
                def initialize
                    super
                end 
            end

            class Bus < Vehicle
                def initialize
                    super
                end 
            end

            #test
            car_1 = Car.new("rojo")
            car_2 = Car.new("verde")
            bus_1 = Bus.new("amarillo")

            p Car.number_of_vehicles == "This Superclass has created 3 vehicles"

            Resultado:
            
            true
            [Finished in 0.6s]

            Ej. Variable de Instancia:
            
            p car_1.color == "rojo"
            p car_2.color == "verde"
            p car_1.color == "amarillo"

            Resultado: 

            true
            true
            true
            [Finished in 0.6s]            

            Los metodos de clase son los que se pueden llamar a nivel clase y deben definirse
            con self en el ejemplo de arriba seria:

            self.number_of_vehicles

            El cual devuelve un valor:

            "This Superclass has created 3 vehicles"

            mientras que un metodo de clase es aquel que puede invocarse desde la instancia 
            del objeto y este no se define con "self". 
            En el ejemplo de arriba:

            car_1.color

            El cual devuelve un valor

            "rojo"

            porque la instancia car_1 fue creada con el argumento del constructoir color 
            puesto en "rojo" y el attr_accessor permite generar un metodo de instancia
            para acceder es decir leer y para actualizar, esto es que tambien podria usarse
            un metodo de instancia de la siguiente manera:

            car_1.color = "negro"

  11. Polymorphism - El polimorfismo suele considerarse el tercer pilar de la programación 
            orientada a objetos, después de la encapsulación y la herencia. Polimorfismo es
            una palabra griega que significa "con muchas formas" y tiene dos aspectos 
            diferentes: 

            En tiempo de ejecución, los objetos de una clase derivada pueden ser tratados 
            como objetos de una clase base en lugares como parámetros de métodos y 
            colecciones o matrices. Cuando ocurre, el tipo declarado del objeto ya no es 
            idéntico a su tipo en tiempo de ejecución.

            Las clases base pueden definir e implementar métodos virtuales, y las clases 
            derivadas o subclases pueden invalidarlos o modificarlos, lo que significa 
            que pueden proporcionar su propia definición e implementación del mismo metodo.

            Ej. de modificacion del comportamiento en tiempo de ejecucion:
            
            class A  
              def a  
                puts 'In class A'  
              end  
            end  
              
            class B < A  
              def a  
                puts 'In class B'  
              end  
            end  
              
            b = B.new  
            b.a  

            El resultado es: 
            
            In class B
            [Finished in 0.8s]

            porque el mismo metodo existe dentro de la sub clase B el cual se ejecuta a ese nivel.
            porque el objeto fue creado a partir de B la cual hereda de A.  Mienstras que si se 
            ejecuta:

            c = A.new
            c.a

            El resultado es: 

            In class A
            [Finished in 0.6s]        

            En los lenguajes debilmente tipados como Ruby no importa el tipo de datos que se declare
            inicialmente este pude cambiar dependiendo del uso que se le de een tiempo de ejecucion
            por ejemplo la variable siguiente:
            
            class MiClase
                @@variable_de_clase = 0
                def initialize
                    @@variable_de_clase = "Hola Mundo!"
                end    
                def self.agrega_datos
                    @@variable_de_clase = []
                    @@variable_de_clase << "PERRO"
                    @@variable_de_clase << { motor: "V8", fruta: "Sandia"}
                    @@variable_de_clase << 1983
                end
            end    
            p MiClase.agrega_datos

            En este ejemplo la variable de clase 'variable_de_clase' originalmente
            se definio como numerica, en el constructor de la clase se cambio a string
            y en tiempo de ejecucion cuando se hizo una llamada al metodo de clase
            'agrega_datos' se modifico a un array, y dentro mismo del array se 
            añadieron strings, hashes y enteros.

            En un lenguaje altamente tipado esto no podria realizarse, si la variable
            es definida como numerica, no podria contener un string o un arreglo, etc.
            esto tambien es parte del polimorfismo.

  12. Separation of Concerns - Es un principio de diseño para separar un programa 
            informático en secciones distintas, tal que cada sección enfoca un interés 
            delimitado. Un interés o una preocupación es un conjunto de información que 
            afecta al código de un programa. 

            Ej. El metodo correr tiene un interes o preocupacion por mover los pies de
            un animal a una velocidad determinada, mientras que el metodo dormir tiene
            el interes especificamente de descansar. 
            
            Básicamente, significa que no se debe de mezclar todas las ideas juntas en 
            un mega programa enorme y dificil de entender, pero si se pueden separar 
            las ideas limpiamente en código. Si no lo hace, es difícil cambiar, probar
            o depurar el código. Si se separan, entonces se tiene cierta libertad para 
            cambiar. Por ejemplo. 

            ** AQUI NO SE COMO SE PUEDE PONER UN EJEMPLO **
=end