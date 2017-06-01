class NumberGuessingGame
	
	#Método initialize sirve para arrancar o construir cada objeto
	@@number_to_guess = 0

	def initialize
        @@number_to_guess = Random.new.rand(0..9)
        # El codigo debajo se utilizo para validar el numero generado.
        #p "Random: #{@@number_to_guess}"
	end

	#Comportamiento
	def guess(number)
		number > @@number_to_guess ? "Too high" : (number < @@number_to_guess ? "Too low" : "You got it!")
	end
end

count = 1
new_game = false
won_games = 0

while true
	if count == 1 
		system ("cls")
		puts "Starting a new game!"
		if won_games > 0
			puts "You already won #{won_games} times, very well!"
		end	
		game = NumberGuessingGame.new
	end
	puts "Guess a number between 0 and 9 or type exit to quit:" 
	number = gets.chomp
	# El codigo debajo se utilizo para validar lo ingresado.
	# p "Number: #{number}"

	if number.length == 4 and (number.downcase == "exit" or number.downcase == "quit")
		break
	elsif number.length == 1 and number.chars.all?{|c|[*'0'..'9'].include?(c)} and (number.to_i >= 0 and number.to_i <= 9)
		message = game.guess(number.to_i)
		if message == "You got it!"
			puts message
			sleep 10
			count = 0
			won_games += 1
		else
			puts message
		end	
	else
		puts "Wrong input!"
	end
	count += 1
end