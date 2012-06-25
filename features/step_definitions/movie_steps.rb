# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

Then /^the director of "(.*)" should be "(.*)"$/ do |arg1, arg2|
  movie = Movie.find_by_title(arg1)
  assert movie.director == arg2
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  exp = e1 + '.*' + e2
  assert /#{exp}/m.match(page.body) != nil
end

# Make it easier to express checking or unchecking several boxes at once
# "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(%r{,\s*}).each do |rating|
    steps %Q{
      When I #{uncheck ? "uncheck" : "check"} "ratings_#{rating}"
    }
  end
end

Then /I should see all movies/ do
  # +1 for the header
  if page.respond_to? :should
    page.should have_css("table#movies tr", :count => Movie.all.count.to_i + 1)
  else
    assert page.has_css?("table#movies tr", :count => Movie.all.count.to_i + 1)
  end
end

Then /I should see no movies/ do
  # +1 for the header
  if page.respond_to? :should
    page.should have_css("table#movies tr", :count => 1)
  else
    assert page.has_css?("table#movies tr", :count => 1)
  end
end
