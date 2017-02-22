# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

comedies = Category.create(name: "Comedies")
dramas = Category.create(name: "Dramas")

Video.create(title: "Braveheart", description: "A movie with Mel Gibson", small_cover_url: "https://en.wikipedia.org/wiki/File:Braveheart_imp.jpg#/media/File:Braveheart_imp.jpg", large_cover_url: "https://en.wikipedia.org/wiki/File:Braveheart_imp.jpg#/media/File:Braveheart_imp.jpg", category: dramas)
Video.create(title: "Matrix", description: "A movie with Keanu Reeves", small_cover_url: "https://en.wikipedia.org/wiki/File:The_Matrix_Poster.jpg#/media/File:The_Matrix_Poster.jpg", large_cover_url: "https://en.wikipedia.org/wiki/File:The_Matrix_Poster.jpg#/media/File:The_Matrix_Poster.jpg", category: dramas)
Video.create(title: "Spiderman", description: "A movie about Spiderman ", small_cover_url: "https://images-na.ssl-images-amazon.com/images/M/MV5BMjMyOTM4MDMxNV5BMl5BanBnXkFtZTcwNjIyNzExOA@@._V1_UX182_CR0,0,182,268_AL_.jpg", large_cover_url: "https://images-na.ssl-images-amazon.com/images/M/MV5BMjMyOTM4MDMxNV5BMl5BanBnXkFtZTcwNjIyNzExOA@@._V1_UX182_CR0,0,182,268_AL_.jpg", category: comedies)

k = User.create(full_name: "Konstantin", password: "password", email: "k@example.com")

Review.create()
