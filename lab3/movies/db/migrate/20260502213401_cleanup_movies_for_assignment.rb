class CleanupMoviesForAssignment < ActiveRecord::Migration[8.1]
  def change
    
    remove_foreign_key :movies, :genres
    remove_index :movies, :genre_id
    remove_column :movies, :genre_id, :bigint


  end
end
