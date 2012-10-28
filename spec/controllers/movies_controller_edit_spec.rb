require 'spec_helper'

describe MoviesController do
  describe 'find similar movies' do
    it 'when I go to the edit page for the Movie, it should be loaded' do
      movie = mock('Movie')
      Movie.should_receive(:find).with('1').and_return(movie)
      get :edit, {:id => '1'}
      response.should be_success
    end

    it 'And I fill in "Director" with "Ridley Scott", And I press "Update Movie Info", it should save the director' do
      movie = mock('Movie')
      movie.stub!(:update_attributes!)
      movie.stub!(:title)
      movie.stub!(:director)
      updmovie = mock('Movie')
      Movie.should_receive(:find).with('1').and_return(movie)
      movie.should_receive(:update_attributes!)
      post :update, {:id => '1', :movie => updmovie}
      flash[:notice].should =~ /successfully updated/
    end
  end
end
