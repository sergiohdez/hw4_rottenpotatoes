# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date], :director => movie[:director])
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |e1, e2|
  assert Movie.find_by_title(e1).director == e2
end

