Given /^I am a new visitor$/ do
  clear_cookies
end

When /^I view "([^\"]*)"$/ do |path|
  visit(path)
end

When /^(\d+) visitors view "([^\"]*)"$/ do |count, path|
  count.to_i.times do
    visit(path)
    clear_cookies
  end
end

When /^I view "([^\"]*)" (\d+) times$/ do |path, count|
  count.to_i.times{visit(path)}
end

Then /^I should see "([^\"]*)"$/ do |content|
  assert_contain(content)
end
