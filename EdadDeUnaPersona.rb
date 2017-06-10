class Persona
	attr_accessor :name, :born_date 
	def initialize(name,born_date)
		@name = name
		@born_date = born_date
	end
	def age
		years_old
	end
	private
	def years_old
		"#{name} is #{Time.new.year.to_i - born_date[0..3].to_i} years old."
	end
end
carlos = Persona.new("Carlos", "1987-08-03")
martha = Persona.new("Martha", "1991-09-16")
#test
#test
p carlos.age == "Carlos is 30 years old."
#=>true
p martha.age == "Martha is 26 years old."
#=>true
sleep 1
p carlos.years_old
#=>private method `years_old'...(NoMethodError)