def hello
  perro = "Doberman"
  yield 10
  puts "Hello... You're in the method"
  yield 20
  puts "Hello... You're in the method again"
  yield perro
  puts "Hello again... You're in the method one more time"
  yield "perro"
end

hello {|parm_from_method| puts "You are in the block #{parm_from_method}"}