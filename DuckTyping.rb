
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