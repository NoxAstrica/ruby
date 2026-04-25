class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :genre
      t.string :director
      t.date :release_date
      t.float :rating
      t.integer :status

      t.timestamps
    end
  end
end
