Movie.destroy_all
Genre.destroy_all

scifi = Genre.create!(name: "Sci-Fi")
drama = Genre.create!(name: "Drama")

Movie.create!(
  title: "Inception",
  genre: scifi,
  director: "Christopher Nolan",
  release_date: "2010-07-16",
  rating: 8.8,
  status: :want_to_watch
)

Movie.create!(
  title: "The Shawshank Redemption",
  genre: drama,
  director: "Frank Darabont",
  release_date: "1994-09-22",
  rating: 9.3,
  status: :watched
)

puts "Success! Seeded #{Movie.count} movies."