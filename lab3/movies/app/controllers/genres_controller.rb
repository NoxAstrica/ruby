class GenresController < ApplicationController
  before_action :set_genre, only: %i[ show edit update destroy ]

  # GET /genres or /genres.json
  def index
    @genres = Genre.all
  end

  # GET /genres/1 or /genres/1.json
  def show
  end

  # GET /genres/new
  def new
    @genre = Genre.new
  end

  # GET /genres/1/edit
  def edit
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      # Change from @genre to genres_path
      redirect_to genres_path, notice: "Genre was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @genre.update(genre_params)
      redirect_to genres_path, notice: "Genre was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  # DELETE /genres/1 or /genres/1.json
  def destroy
    @genre.destroy!

    respond_to do |format|
      format.html { redirect_to genres_path, notice: "Genre was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_genre
      @genre = Genre.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def genre_params
      params.expect(genre: [ :name ])
    end
end
