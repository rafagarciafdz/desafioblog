# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Post.destroy_all
Comment.destroy_all
Vote.destroy_all
User.destroy_all

user = User.create(email:"rafael@mail.com", password:"12345678", name:"Rafael")

100.times do |i|
	post = user.posts.create(title:"Soy el Post #{i}", content: "Soy el contenido del Post #{i}")
end