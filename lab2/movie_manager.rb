require 'json'
require 'yaml'

class MovieManager
  attr_accessor   :collection

  def initialize
    @collection = {}
  end

  def each(&block)
    @collection.each_value(&block)
  end

  def add(title:, genres: [], directors: [], actors: [], release_date:, rating:, status:)

    unless valid_movie_data?(title, release_date, genres, directors, actors)
      return nil
    end

    id = (@collection.keys.max || 0) + 1
    @collection[id] = Movie.new(
      id: id,
      title: title,
      genres: genres,
      directors: directors,
      actors: actors,
      release_date: release_date,
      rating: rating,
      status: status
    )
  end

  def valid_movie_data?(*args)
    is_invalid = args.any? do |arg|
      if arg.is_a?(Array)
        arg.empty? || arg.all? { |item| item.to_s.strip.empty? }
      else
        arg.to_s.strip.empty?
      end
    end
    if is_invalid
      puts "Error: All fields must be filled out!"
      return false
    end
    true
  end

  def edit_movie(id, new_info)
    movie = @collection[id]
    if movie
      new_info.each do |key, value|
        setter = "#{key}="
        movie.public_send(setter, value) if movie.respond_to?(setter)
      end
    else
      puts  "Movie with ID #{id} not found"
    end
  end

  def delete_movie(id)
    @collection.delete(id) || puts("Movie with ID #{id} not found")
  end

  def list_movies
    if @collection.empty?
      puts "No movies found"
    else
      @collection.each do |id, m|
        puts "[#{id}] #{m.title} | #{m.genres.join(', ')} | #{m.directors.join(', ')} | #{m.actors.join(', ')} | #{m.release_date} | #{m.rating} | #{m.status}"
      end
    end
  end

  def find_by_title(part_title)
      @collection.select { |_, m| m.title.downcase.include?(part_title.downcase) }
  end

  def filter_by_genre(genre)
      @collection.select { |_, m| m.genres.any? { |g| g.downcase == genre.downcase } }
  end

  def filter_by_director(director)
      @collection.select { |_, m| m.directors.any? { |d| d.downcase == director.downcase} }
  end

  def save_to_json(filename)
      hash_info = @collection.transform_values(&:to_h)
      File.write(filename, JSON.pretty_generate(hash_info))
      puts "Saved in #{filename}"
  rescue => e
      puts "Error during saving: #{e.message}"
  end

  def load_from_json(filename)
    data = JSON.parse(File.read(filename), symbolize_names: true)
    @collection = {}
    data.each do |id, movie_hash|
      @collection[id.to_s.to_i] = Movie.from_h(id, movie_hash)
    end
    puts "Loaded from #{filename}"
  rescue => e
    puts "File #{filename} not found"
    @collection = {}
  end

  def save_to_yaml(filename)
    hash_info = @collection.transform_values(&:to_h)
    File.write(filename, hash_info.to_yaml)
    puts "Saved in #{filename}"
  rescue => e
    puts "Error during saving: #{e.message}"
  end

  def load_from_yaml(filename)
    return unless File.exist?(filename)
    
    data = YAML.unsafe_load_file(filename)
    @collection = {}
    
    # If the file was empty or invalid, data might be nil or not a hash
    return unless data.is_a?(Hash)

    data.each do |id, movie_hash|
      # If movie_hash is actually a Movie object (old format), 
      # we convert it to a hash first so from_h can handle it.
      actual_hash = movie_hash.is_a?(Hash) ? movie_hash : movie_hash.to_h
      @collection[id.to_s.to_i] = Movie.from_h(id, actual_hash)
    end
    puts "Loaded from #{filename}"
  rescue => e
    puts "Error loading YAML: #{e.message}" # This will tell you if it's a format issue!
    @collection = {}
  end

end

#################################################
