require 'json'
require 'yaml'

STATUSES = ['want_to_watch', 'watching', 'watched']

def add_movie(movies, title, genres, directors, actors, release_date, rating, status)
    id = movies.keys.max.to_i + 1

    unless STATUSES.include?(status)
        puts "Invalid status, can't add the movie"
    else
        movies[id] = {
            title: title,
            genres: genres,
            directors: directors,
            actors: actors,
            release_date: release_date,
            rating: rating,
            status: status
        }
    end
    movies   
end

def edit_movies(movies, id, new_data)
    if movies[id]
        movies[id].merge!(new_data)
    else
        puts "Movie with ID #{id} not found"
    end
    movies
end

def delete_movie(movies, id)
    if movies[id]
        movies.delete(id)
    else
        puts "Movie with ID #{id} not found"
    end
    movies
end

def list_movies(movies)
    movies.each do |id, m|
        puts "[#{id}] #{m[:title]} | #{m[:genres].join(', ')} | #{m[:directors].join(', ')} | #{m[:actors].join(', ')} | #{m[:release_date]} | #{m[:rating]} | #{m[:status]}"
    end
end

def find_by_title(movies, part_title)
    movies.select { |_, m| m[:title].downcase.include?(part_title.downcase) }
end

def filter_by_genre(movies, genre)
    movies.select { |_, m| m[:genres].any? { |g| g.downcase == genre.downcase } }
end

def filter_by_director(movies, director)
    movies.select { |_, m| m[:directors].any? { |d| d.downcase == director.downcase} }
end

########################

def save_to_json(movies, filename)
    File.write(filename, JSON.pretty_generate(movies))
    puts "Saved in #{filename}"
rescue => e
    puts "Error during saving: #{e.message}"
end

def load_from_json(filename)
    data = JSON.parse(File.read(filename))

    data.transform_keys(&:to_i).transform_values do |v|
        v.transform_keys(&:to_sym)
    end
rescue Errno::ENOENT
    puts "File #{filename} not found"
    {}
end

def save_to_yaml(movies, filename)
    File.write(filename, movies.to_yaml)
    puts "Saved in #{filename}"
rescue => e
    puts "Error during saving: #{e.message}"
end

def load_from_yaml(filename)
    YAML.load_file(filename)
rescue Errno::ENOENT
    puts "File #{filename} not found"
    {}
end

#################################

movies = {
  1 => {
    title: "Inception",
    genres: ["Sci-Fi", "Action", "Thriller"],
    directors: ["Christopher Nolan"],
    actors: ["Leonardo DiCaprio", "Tom Hardy"],
    release_date: "2010-07-16",
    rating: 8.8,
    status: "want_to_watch"
  },
}
list_movies(movies)

add_movie(movies, "The Shawshank Redemption", ["Drama"], ["Frank Darabont"], ["Tim Robbins", "Morgan Freeman"], "1994-09-23", 9.3, "watched")
list_movies(movies)

# results = find_by_title(movies, "incep")
# p results

# scifi_movies = filter_by_genre(movies, "Sci-Fi")
# p scifi_movies

# edit_movies(movies, 3, { rating: 9.0, status: "watched" })
# list_movies(movies)

# delete_movie(movies, 2)
# list_movies(movies)

# #########

# save_to_json(movies, "test_movies.json")
# loaded_movies = load_from_json("test_movies.json")
# puts "Loaded movie title: #{loaded_movies[1][:title]}"

# save_to_yaml(movies, "test_movies.yaml")
# loaded_movies = load_from_yaml("test_movies.yaml")
# puts "Loaded movie release dade: #{loaded_movies[1][:release_date]}"