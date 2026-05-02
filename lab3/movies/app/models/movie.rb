class Movie < ApplicationRecord

  enum :status, { want_to_watch: 0, watching: 1, watched: 2 }

  validates :title, :director, :release_date, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end
