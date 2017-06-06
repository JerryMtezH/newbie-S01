class Person
  attr_accessor :first_name, :last_name, :email
  attr_reader :information, :name

  def initialize(first_name, last_name, email)
    @first_name = first_name
    @last_name = last_name
    @email = email
  end

  def name
  	puts "#{@first_name + " " + @last_name}"
  end

  def information
  	puts "Name: #{@first_name +" "+ @last_name}"
  	puts "Email: #{@email}" 
  end

end
person = Person.new('Daniel', 'Garcia', 'daniel@mail.com')
person.name
# => Daniel Garcia
person.information
# => Name: Daniel Garcia
# => Email: daniel@mail.com