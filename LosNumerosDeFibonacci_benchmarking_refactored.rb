require 'benchmark'

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

# Recursivo refactored.
def fibonacci_recursive_refactored(limit)
	if limit < 2
		return limit
	elsif limit >= 2
		if instance_variable_get("@result#{limit}")
           return instance_variable_get("@result#{limit}")
        else   
           instance_variable_set("@result#{limit}", (fibonacci_recursive_refactored(limit-2) + fibonacci_recursive_refactored(limit-1)) )
        end      
    end   
end

n = 1000
Benchmark.bm(7) do |x|
  x.report("Iterative:")   { for i in 1..n; fibonacci_iterative(20) ; end }
  x.report("Recursive:")   { for i in 1..n; fibonacci_recursive(20) ; end }
  x.report("Rec_&_Ref:")   { for i in 1..n; fibonacci_recursive_refactored(20) ; end }
end