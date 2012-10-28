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

  describe 'not find similar movies' do
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

  describe 'actions in the index page' do
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

    it 'should show Movie by id' do
      movie = mock('Movie')
      Movie.should_receive(:find).with('1').and_return(movie)
      get :show, {:id => '1'}
    end

    it 'should be possible to create movie' do
      movie = mock('Movie')
      movie.stub!(:title)
      Movie.should_receive(:create!).and_return(movie)
      post :create, {:movie => movie}
      response.should redirect_to(movies_path)
    end

    it 'should be possible to destroy movie' do
      movie = mock('Movie')
      movie.stub!(:title)
      Movie.should_receive(:find).with('1').and_return(movie)
      movie.should_receive(:destroy)
      post :destroy, {:id => '1'}
      response.should redirect_to(movies_path)
    end

    it 'should redirect if sort order has been changed' do
      session[:sort] = 'release_date'
      get :index, {:sort => 'title'}
      all_ratings = {'G' => 'G', 'PG' => 'PG', 'PG-13' => 'PG-13', 'NC-17' => 'NC-17', 'R' => 'R'}
      response.should redirect_to(movies_path(:sort => 'title', :ratings => all_ratings))
    end
    it 'should be possible to order by release date' do
      get :index, {:sort => 'release_date'}
      all_ratings = {'G' => 'G', 'PG' => 'PG', 'PG-13' => 'PG-13', 'NC-17' => 'NC-17', 'R' => 'R'}
      response.should redirect_to(movies_path(:sort => 'release_date', :ratings => all_ratings))
    end
    it 'should redirect if selected ratings are changed' do
      get :index, {:ratings => {:G => 1}}
      response.should redirect_to(movies_path(:ratings => {:G => 1}))
    end
    it 'should call database to get movies' do
      Movie.should_receive(:find_all_by_rating)
      get :index
    end
  end

end
