def prime(max_number)
	prime_numbers = []
	primes_selected = 0
	for number in 1..max_number
		# Siguiente codigo para ver que numero se procesa.
  		# p "number = #{number}"
	  	if number > 0 
	  		d = 0
	  		for c in 1..number
	  			# Siguiente codigo para ver que numero 
	  			# del 1 al numero del arreglo se procesa.
  		        # p "c = #{c}"
				if number % c == 0
			    	d += 1
				end
				if d > 2
					break
				end	
			end
			if d == 2
				# Siguiente codigo para vercuando es primo.
				# p "Es numero Primo"
				if primes_selected < 10
					prime_numbers << number
					primes_selected += 1
				end
			end
		end	
	end
	yield prime_numbers   	
end
prime(39) {|arr| puts "#{arr}" }