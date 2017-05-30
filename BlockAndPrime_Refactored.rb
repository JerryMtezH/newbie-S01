def prime
	require 'mathn'
	prime_numbers = Prime.first 10
	yield prime_numbers   	
end
prime {|arr| puts "#{arr}" }