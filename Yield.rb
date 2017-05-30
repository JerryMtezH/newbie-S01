def hello
  puts "Hello... You're in the method"
  yield
  puts "Hello again... You're back to the method"
  yield
end

hello {puts "You are in the block"}