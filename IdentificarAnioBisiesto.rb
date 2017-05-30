def leap_year?(year)
	#if year % 400 == 0
	#	true
	#else	
	#	if year % 4 == 0 and year % 100 != 0
	#		true
	#	else
	#		false
	#	end
	#end	 
	year % 400 == 0 ? true :(year % 4 == 0 and year % 100 != 0) ? true : false
end
p leap_year?(1900) == false
p leap_year?(1988) == true
p leap_year?(1989) == false
p leap_year?(1992) == true
p leap_year?(2000) == true
p leap_year?(2001) == false
p leap_year?(1600) == true  
p leap_year?(1704) == true