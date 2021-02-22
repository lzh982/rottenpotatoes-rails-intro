class MoviesController < ApplicationController
  helper_method :hilite

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
#    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    if(params.has_key?(:ratings))
      @ratings_to_show = params[:ratings].keys
    end
    @ratings = params[:ratings]
    @movies = Movie.with_ratings(params[:ratings])
    
    @sort_by = params[:sort_by]
    @movies = @movies.order(params[:sort_by])
    @hilite_release_date = ''
    @hilite_movie_title = ''
    hilite(@sort_by)
    


  end


  def hilite(type)

    if(@sort_by == 'release_date')
      @hilite_release_date =  "bg-warning"
    elsif @sort_by == "title"
      @hilite_movie_title = "bg-warning"
    end
  
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
