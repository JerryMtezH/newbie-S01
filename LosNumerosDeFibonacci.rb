# Iterativo
def fibonacci_iterative(limit)
	if limit == 0 || limit == 1
	    return limit
	elsif limit >= 2    
		result = []
		(limit+1).times do |x|
			if x == 0
				result << 0
			elsif x == 1 or x == 2
				result << 1
			elsif x > 2
				result << result[x-2] + result[x-1]
			end	
		end
		return result[limit]
	end  
end

# Recursivo.
def fibonacci_recursive(limit)
	if limit == 0 || limit == 1
		return limit
	elsif limit > 1
		fibonacci_recursive(limit-1) + fibonacci_recursive(limit-2)
	end  
end
p fibonacci_iterative(0) == 0
p fibonacci_iterative(1) == 1
p fibonacci_iterative(2) == 1
p fibonacci_iterative(3) == 2
p fibonacci_iterative(4) == 3
p fibonacci_iterative(5) == 5
p fibonacci_iterative(6) == 8
p fibonacci_iterative(7) == 13
p fibonacci_iterative(8) == 21
p fibonacci_iterative(9) == 34
p fibonacci_iterative(10) == 55

p fibonacci_recursive(0) == 0
p fibonacci_recursive(1) == 1
p fibonacci_recursive(2) == 1
p fibonacci_recursive(3) == 2
p fibonacci_recursive(4) == 3
p fibonacci_recursive(5) == 5
p fibonacci_recursive(6) == 8
p fibonacci_recursive(7) == 13
p fibonacci_recursive(8) == 21
p fibonacci_recursive(9) == 34
p fibonacci_recursive(10) == 55
