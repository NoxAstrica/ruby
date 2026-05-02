# seeds.rb
Movie.destroy_all
Genre.destroy_all

sci_fi = Genre.create!(name: "Sci-Fi")
drama = Genre.create!(name: "Drama")

Movie.create!(
  title: "Inception",
  genre: sci_fi.name,
  director: "Christopher Nolan",
  release_date: "2010-07-16",
  rating: 8.8,
  status: :want_to_watch
)

Movie.create!(
  title: "The Shawshank Redemption",
  genre: drama.name,
  director: "Frank Darabont",
  release_date: "1994-09-22",
  rating: 9.3,
  status: :watched
)
