# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Product.destroy_all
let product1 = Product.create({:name=>"tomato", :description =>"red", :price => 1, :stock=> 1})
let product2 = Product.create({:name=>"milk", :description =>"white",:price => 3, :stock=> 2 })
let product3 = Product.create({:name=>"bread", :description =>"brown",:price => 5.50 , :stock=> 3})
let product4 = Product.create({:name=>"bacon", :description =>"pink",:price => 10, :stock=> 4})
let product5 = Product.create({:name=>"cheese", :description =>"yellow",:price => 3.20, :stock=> 5})
