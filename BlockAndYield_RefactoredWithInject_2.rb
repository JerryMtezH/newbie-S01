#método que usa yield para llamar al bloque 
def average_grade
  grades = [10,5,9,7,3,8]
  puts "------------Time started----------------"
  start_time = Time.new
  puts "Start time: #{start_time}"
  puts ""
  yield grades
  puts ""
  end_time = Time.new
  puts "End time: #{end_time}"
  puts "------------Time finished---------------"
  elapsed_time = end_time - start_time
  puts "Result: #{elapsed_time} seconds"
  return ""
end

#Bloque para calcular el promedio de calificaciones
average_grade { |grades| p "Average: #{( grades.inject (0) { |average, grade| average + grade } ) / grades.count.to_f }" }