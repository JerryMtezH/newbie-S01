#each_with_index ------------------------------------------------------------------------------------------------
def odd_indexed(array)
	arr = []
	array.each_with_index { |item, index|
		#p "#{index}.even? : #{index.even?}"
		index.even? ? arr << item : ""
	}
	return arr
end

#select --------------------------------------------------------------------------------------------------------
def long_strings(array)
	array.select { |i| i.length >= 5 }  
end	

#find ----------------------------------------------------------------------------------------------------------
def start_with_h(array)
	array.find { |i| i[0].downcase == 'h' }.to_s
end	

#flat_map ------------------------------------------------------------------------------------------------------
def capitalize_array(array)
	array.flat_map {|i| i.capitalize }
end	

#group_by o inject ---------------------------------------------------------------------------------------------
def group_by_starting_letter(array)
	#Hecho a Mano (Lo hice antes de encontrar group_by)
	#array.inject({}){|h,f|k = f[0];h[k] ||= [];h[k] << f; h}
	#group_by
	array.group_by { |i| i[0] }
end	

#start_with_h---------------------------------------------------------------------------------------------------
def number_of_r(string)
	string.split("").find_all { |i| i.downcase == 'r' }.count
end	

 

p odd_indexed(["uno", "dos", "tres", "cuatro", "cinco"]) == ["uno", "tres", "cinco"]
p long_strings(["rojo", "morado", "azul", "negro", "blanco", "naranja"]) == ["morado", "negro", "blanco", "naranja"]
p start_with_h(["manzana", "naranja", "sandia", "higo", "melon", "platano"]) == "higo"
p capitalize_array(["manuel", "juan", "rodrigo", "ana", "paola"]) == ["Manuel", "Juan", "Rodrigo", "Ana", "Paola"]
p group_by_starting_letter(["arbol", "amarillo", "angel", "burro", "barco"]) == {"a"=>["arbol", "amarillo", "angel"], "b"=>["burro", "barco"]}
p number_of_r("ferrocarril") == 4