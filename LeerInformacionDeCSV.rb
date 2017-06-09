require 'csv'
class Person

	@@personas = []

	def initialize(first_name, last_name, email, phone)
	    @first_name = first_name
	    @last_name = last_name
	    @email = email
	    @phone = phone
	    @created_at = Time.new 
	    @@personas << {first_name: @first_name, last_name: @last_name, email: @email, phone: @phone, created_at: @created_at}
	end
	def self.personas
		@@personas
	end	
end

class PersonParser
	@@persons_parsed = []
	def initialize(file)
		CSV.foreach(file, headers: true) do |row|
  			@@persons_parsed << row.to_hash
		end
	end
	def people
		@@persons_parsed.map {|i| Person.new(i["first_name"],i["last_name"],i["email"],i["phone"]) }
	end	
end

parser = PersonParser.new('outfile.csv')
array = parser.people
p Person.personas.first(10)