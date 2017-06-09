require 'faker'
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

	def self.escribe_personas
		CSV.open('outfile.csv','wb', col_sep: ",") do |csvfile|
			csvfile << @@personas.first.keys
			@@personas.each do |row|
    			csvfile << row.values
  			end
  		end
	end
end

20.times { Person.new(Faker::Name.first_name,Faker::Name.last_name,Faker::Internet.email,Faker::Number.number(10)) }
Person.escribe_personas