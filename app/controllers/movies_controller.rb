class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if session[:ses_params] == nil 
      session[:ses_params] = { :sort => nil, :ratings => nil }
      #session[:params[:ratings]] = Hash.new(Movie.all_ratings => 1) # create "checked" hash
    end
    redirect = false
    if params.size == 0 ; redirect = true ; end
    session[:ses_params].keys.each do |paramkey|
      # check if params are in params hash, also decide if redirect is needed
      if params.has_key? paramkey
        if session[:ses_params][paramkey] != params[paramkey]
          session[:ses_params][paramkey] = params[paramkey] # if params have changed, overwrite with new ones
          redirect = true
        end
      else
        redirect = true unless session[:ses_params][paramkey] == nil # if params was missing some session params, redirect to include these session params
      end
    end
    if redirect ; redirect_to movies_path(session[:ses_params]) ; end
    @sort = params[:sort]
    if params[:ratings]
      @checked_ratings = params[:ratings]
      @movies = Movie.find_all_by_rating(@checked_ratings.keys)
      @movies = @movies.sort_by {|movie| movie.send(@sort)} unless @sort == nil
    else
      @checked_ratings = Hash.new
      @movies = Movie.all :order => @sort
    end
    @all_ratings = Movie.all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(session)
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
