def total_between_age(arr,min,max)
	count = 0
	arr.each {|i| count += ((i >= min and i <= max) ? 1 : 0) }
	count
end
# Pruebas
p total_between_age([10, 20, 30, 40, 50, 60], 20, 40) == 3
p total_between_age([18, 19, 20, 23, 24, 27], 20, 27) == 4