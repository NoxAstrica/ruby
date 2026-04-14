STATUSES = ['want_to_watch', 'watching', 'watched']

class Movie
  attr_reader     :id, :status
  attr_accessor   :title, :genres, :directors, :release_date, :actors, :rating     

  def status=(status_name)
    unless STATUSES.include?(status_name)
      raise ArgumentError, "Invalid status of the movie. Must be either of: #{STATUSES}"
    end
    @status = status_name
  end

  def rating=(num)
    raw_val = num.to_s.strip
    unless raw_val =~ /^-?\d+(\.\d+)?$/
      raise ArgumentError, "Rating must be a valid number (e.g., 8 or 8.5)"
    end

    val = raw_val.to_f
    if val < 0.0 || val > 10.0
      raise ArgumentError, "Rating must be between 0.0 and 10.0"
    end

    @rating = val
  end

  def release_date=(date_str)
    #YYYY-MM-DD
    unless date_str =~ /^\d{4}-\d{2}-\d{2}$/
      raise ArgumentError, "Invalid date format. Must be YYYY-MM-DD"
    end
    
    begin
      Date.iso8601(date_str)
    rescue Date::Error
      raise ArgumentError, "That date doesn't exist!"
    end

    @release_date = date_str
  end

  def initialize(id:, title:, genres: [], directors: [], actors: [], release_date:, rating:, status:)
    @id = id
    @title = title
    @genres = genres
    @directors = directors
    @actors = actors
    self.release_date = release_date
    self.rating = rating
    self.status = status
  end

  def to_h
    {
      title: @title,
      genres: @genres,
      directors: @directors,
      actors: @actors,
      release_date: @release_date,
      rating: @rating,
      status: @status
    }
  end

  def self.from_h(id, hash)
    new(
      id: id.to_i,
      title: hash[:title],
      genres: hash[:genres],
      directors: hash[:directors],
      actors: hash[:actors],
      release_date: hash[:release_date],
      rating: hash[:rating],
      status: hash[:status]
    )
  end

end