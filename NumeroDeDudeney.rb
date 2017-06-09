def dudeney_number?(number)
	r = 0
	number.to_s.split("").each {|n| r = (r+n.to_i) }
	(r*r*r) == number
end
p dudeney_number?(1) == true
p dudeney_number?(125) == false
p dudeney_number?(512) == true
p dudeney_number?(1_728) == false
p dudeney_number?(5_832) == true