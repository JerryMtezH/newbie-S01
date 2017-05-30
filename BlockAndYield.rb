#método que usa yield para llamar al bloque 
def average_grade
  puts "------------Time started----------------"
  start_time = Time.new
  puts "Start time: #{start_time}"
  puts ""
  p "Average: #{yield}"
  puts ""
  end_time = Time.new
  puts "End time: #{end_time}"
  puts "------------Time finished---------------"
  elapsed_time = end_time - start_time
  puts "Result: #{elapsed_time} seconds"
  return ""
end

#método para calcular el promedio de calificaciones
def average_grades(grades)
  count = 0
  average = 0
  grades.each{ |grade|
  	 average += grade
     count += 1
  }
  average.to_f / count
end
puts average_grade { average_grades([10,5,9,7,3,8]) } 