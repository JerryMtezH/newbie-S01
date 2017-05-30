#Ejemplo con do...end
3.times do
  puts "Three times"
end

#Ejemplo con {}
numbers = [1, 5, 2, 6, 9, 20]
numbers.each {|number| puts number }

#Ejemplo con do...end
string_list = ""
chars_list_1 = ["a", "b", "c", "d", "e"]
chars_list_2 = ["z", "t", "u", "w", "q"]
chars_list_1.each do |char1|
  # Siguiente codigo para validar el contenido de char1 cada vez
  # dentro del do.
  # p char1
  chars_list_2.each do |char2|
  	# Siguiente codigo para validar el contenido de char2 cada vez
    # dentro del do.
    # p char2
    string_list << char1 << char2
    # Siguiente codigo para ver como se va armando el string.
    # dentro del segundo do.
    # p string_list
  end
end

p string_list
#=> "azatauawaqbzbtbubwbqczctcucwcqdzdtdudwdqezeteueweq"