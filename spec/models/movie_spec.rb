require 'spec_helper'

describe MoviesController do
  describe 'find movies by director' do
    it 'has to return a list of movies' do
      similars = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:find_similars).and_return(similars)
      movies = Movie.find_similars('director')
      movies.length.should == 2
    end
  end
end
