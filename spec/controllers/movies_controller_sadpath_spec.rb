require 'spec_helper'

describe MoviesController do
  describe 'find similar movies' do
    it 'should follow the route to the similar movies by director page' do
      assert_routing('movies/1/director', {:controller => 'movies', :action => 'director', :id => '1'}) 
    end

    it 'should find the similar movies by director' do
      movie = mock('Movie')
      movie.stub!(:director).and_return('George Lucas')
      similars = [mock('Movie'),mock('Movie')]
      Movie.should_receive(:find).with('1').and_return(movie)
      Movie.should_receive(:find_similars).with(movie.director).and_return(similars)
      get :director, {:id => '1'}
    end

    it 'should redirect to index if movie does not have a director' do
      movie = mock('Movie')
      movie.stub!(:title).and_return(nil)
      movie.stub!(:director).and_return(nil)
      Movie.should_receive(:find).with('1').and_return(movie)
      get :director, {:id => '1'}
      response.should redirect_to(movies_path)
      flash[:notice].should =~ /has no director info/
    end
  end
end
