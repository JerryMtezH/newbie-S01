def first_letters(str)
	arr = []
	str.split(" ").each {|element| arr << element[0] }
	return arr
end 
p first_letters("Hoy es miércoles y hace sol") == ["H", "e", "m", "y", "h", "s"]
p first_letters("tienes ocho candados indios nuevos omega") == ["t", "o", "c", "i", "n", "o"]