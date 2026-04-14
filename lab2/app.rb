require_relative 'movie'
require_relative 'movie_manager'

def clear_screen
  system('clear') || system('cls')
end

def prompt(text)
  print "#{text}: "
  gets.chomp
end

def handle_add(manager)
  puts "\nAdding a New Movie"
  title        = prompt("Enter title")

  genres       = prompt("Enter genres (comma separated)").split(',').map(&:strip)
  directors    = prompt("Enter directors (comma separated)").split(',').map(&:strip)
  actors       = prompt("Enter actors (comma separated)").split(',').map(&:strip)
  release_date = prompt("Enter release date (YYYY-MM-DD)")
  rating       = prompt("Enter rating (e.g., 8.5)")
  status       = prompt("Enter status (watched/watching/want_to_watch)")

  begin
    result = manager.add(
      title: title,
      genres: genres,
      directors: directors,
      actors: actors,
      release_date: release_date,
      rating: rating,
      status: status
    )
  
    puts "Successfully added '#{title}' to the collection!"
  rescue ArgumentError => e
    puts "\n[ERROR] Could not add movie: #{e.message}"
    puts "Please try again with valid data."
  end

end

def handle_edit(manager)
  id = prompt("Enter movie id to edit").to_i
  movie = manager.collection[id]

  unless movie
    puts "Movie id #{id} not found."
    return
  end

  puts "Fields: title, genres, directors, actors, release_date, rating, status"
  field = prompt("Which field to update?").downcase.to_sym

  if movie.respond_to?(field)
    current_val = movie.public_send(field)

    if current_val.is_a?(Array)
      puts "Current #{field}: #{current_val.join(', ')}"
      idx = prompt("Enter index to update (0, 1, 2...)").to_i
      new_item = prompt("Enter new value for #{field}[#{idx}]")
      current_val[idx] = new_item
      manager.edit_movie(id, { field => current_val })

    else
      new_val = prompt("Enter new #{field} (Current: #{current_val})")
      new_val = new_val.to_f if field == :rating
      manager.edit_movie(id, { field => new_val })
    end
    puts "Successfully updated #{field}"
  else
    puts "Invalid field name"
  end
end

def handle_search(manager, type)
  results = case type
            when :title    then manager.find_by_title(prompt("Enter title or a piece of title"))
            when :genre    then manager.filter_by_genre(prompt("Enter genre"))
            when :director then manager.filter_by_director(prompt("Enter director"))
            end

  if results && results.any?
    puts "\nFound #{results.count}:"
    results.each { |id, m| puts "[#{id}] #{m.title} | Rating: #{m.rating} | Status: #{m.status}" }
  else
    puts "No movies found."
  end
end

###################################################

manager = MovieManager.new

loop do
  print "Load from YAML - 1, JSON - 2, or start fresh - 3: "
  choice = gets.chomp

  case choice
  when "1"
    if File.exist?('movies.yaml') && File.size('movies.yaml') > 0
      manager.load_from_yaml('movies.yaml')
    else
      puts "YAML file is missing or empty. Starting fresh."
    end
    break
  when "2"
    if File.exist?('movies.json') && File.size('movies.json') > 0
      manager.load_from_json('movies.json')
    else
      puts "JSON file is missing or empty. Starting fresh."
    end
    break
  when "3"
    puts "Starting with an empty collection."
    break
  else
    puts "Invalid selection. Please enter 1, 2, or 3."
    puts "------------------------------------------"
  end
end

begin
  loop do
    puts "\nMovie manager"
    puts "1 - list all movies"
    puts "2 - add a movie"
    puts "3 - edit a movie"
    puts "4 - delete a movie"
    puts "5 - filter by title"
    puts "6 - filter by genre"
    puts "7 - filter by director"
    puts "8 - Save to JSON"
    puts "9 - Save to YAML"
    puts "0 - exit!"

    choice = prompt("Select an option")
    puts "\n"

    case choice
    when "1"
      manager.list_movies
    when "2"
      handle_add(manager)
    when "3"
      handle_edit(manager)
    when "4"
      id = prompt("Enter movie id to delete").to_i
      manager.delete_movie(id)
    when "5"
      handle_search(manager, :title)
    when "6"
      handle_search(manager, :genre)
    when "7"
      handle_search(manager, :director)
    when "8"
      manager.save_to_json('movies.json')
    when "9"
      manager.save_to_yaml('movies.yaml')
    when "0"
      puts "Exiting!"
      break
    else
      puts "Unavailable. Pick out of the available options"
    end
  end

ensure
  if manager.collection && manager.collection.any?
    manager.save_to_yaml('movies.yaml')
    puts "\nAutosaved into movies.yaml"
  else
    puts "\nCollection is empty. Skipping autosave"
  end
end