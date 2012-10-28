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

    it 'should select the Similiar Movies template for rendering' do
      movie = mock('Movie')
      movie.stub!(:director).and_return('George Lucas')
      similars = [mock('Movie'),mock('Movie')]
      Movie.should_receive(:find).with('1').and_return(movie)
      Movie.should_receive(:find_similars).with(movie.director).and_return(similars)
      get :director, {:id => '1'}
      response.should render_template('director')
    end

    it 'should make the results available to the template' do
      movie = mock('Movie')
      movie.stub!(:director).and_return('George Lucas')
      similars = [mock('Movie'),mock('Movie')]
      Movie.should_receive(:find).with('1').and_return(movie)
      Movie.should_receive(:find_similars).with(movie.director).and_return(similars)
      get :director, {:id => '1'}
      assigns(:movies).should == similars
    end
  end
end
