# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(username: 'test', password: 'test')
User.create!(username: 'cat', password: 'cat')

Sub.create!(title: 'Cats', description: 'this is a cat sub about cats')
Sub.create!(title: 'Dogs', description: 'this is a dog sub about dogs')

# Post.create!
