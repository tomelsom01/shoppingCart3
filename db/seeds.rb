# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

# Clear existing data (optional, be cautious with this)
Product.destroy_all # Optional: Be cautious with this line; it will delete all existing products.

Product.create(name: "tomato", description: "red", price: 1, stock: 1)
Product.create(name: "milk", description: "white", price: 3, stock: 2)
Product.create(name: "bread", description: "brown", price: 5.50, stock: 3) # This one already exists
Product.create(name: "bacon", description: "pink", price: 10, stock: 4)
Product.create(name: "cheese", description: "yellow", price: 3.20, stock: 5)
