puts "Destroying all monuments"
Monument.destroy_all

puts "Destroying all users"
User.destroy_all

puts "Destroying all histories"
History.destroy_all

puts "Done destroying"

User.create!(
  first_name: "guest",
  last_name: "Ramos",
  email: "louisramosdev@gmail.com",
  password: "password"
)
