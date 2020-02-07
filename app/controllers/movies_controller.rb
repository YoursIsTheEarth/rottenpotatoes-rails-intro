class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = ''
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    @ratings = []

    if params[:ratings]
      params[:ratings].each {|key, val| @ratings << key}
      session[:ratings] = @ratings
    elsif session[:ratings]
      @ratings = session[:ratings]
    else
      @ratings = @all_ratings
    end
    
    if params[:sort]
      @sort = params[:sort]
      session[:sort] = @sort
      if params[:sort] == 'title'
        @title_style = 'hilite'
      elsif params[:sort] == 'release_date'
        @date_style = 'hilite'
      end
    elsif session[:sort]
      @sort = session[:sort]
      if session[:sort] == 'title'
        @title_style = 'hilite'
      elsif session[:sort] == 'release_date'
        @date_style = 'hilite'
      end
    else
      @movies = Movie.all
    end
    
    @movies = Movie.where(:rating => @ratings).order(@sort)

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

end
