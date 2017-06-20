require 'sqlite3'

class Chef

  def initialize
    SQLite3::Database.new("chefs.db")
  end

  def all
    db.execute(
      <<-SQL
        SELECT * FROM chefs
      SQL
    )
  end

  def where(field, value)
    db.execute("select * from chefs where " + field.strip + " = " + value)
  end

  def save(values)
    q = "INSERT INTO chefs (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES (" + values + ", DATETIME('now'), DATETIME('now'));"
    db.execute(q)
  end

  def delete(field, value)
    db.execute("delete from chefs where " + field.strip + " = " + value)
  end

  private

  def db
    SQLite3::Database.new("chefs.db")
  end

end
# Crea la Instancia de BD. 
a = Chef.new

puts "Muestra el 100% de los registros existentes ------------------------ "
p a.all

puts "Obtiene Registros con la sentencia Where --------------------------- "
p a.where('first_name', "'Ferran'")
p a.where('id', "2")
p a.where('phone','324445214558')

puts "Muestra uno por uno ------------------------------------------------ "
a.all.each { |s| p s }

puts "Adiciona 4 nuevos Chefs -------------------------------------------- "
a.save("'Martha','Paramo','1980-01-01','martha@gmail.com','132132132123'")  
a.save("'Pedro','Rodriguez','1981-11-01','pedro@gmail.com','54545452234'")  
a.save("'Edgar','Garcia','1970-12-01','edgar.garcia@gmail.com','8884574745666'")  
a.save("'Chucho','Juarez','1985-08-05','juarez.chucho@gmail.com','989896776343'")  

puts "Muestra uno por uno incluyendo los registros añadidos -------------- "
a.all.each { |s| p s }

puts "Elimina los 4 añadidos recientemente ------------------------------- "
a.delete('first_name', "'Martha'")
a.delete('first_name', "'Pedro'")
a.delete('first_name', "'Edgar'")
a.delete('first_name', "'Chucho'")

puts "Muestra uno por para validar los registros borrados ---------------- "
a.all.each { |s| p s }
