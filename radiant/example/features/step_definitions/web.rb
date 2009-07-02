Given /^I am a new visitor$/ do
  clear_cookies
end

When /^I view "([^\"]*)"$/ do |path|
  visit(path)
end

Then /^I should see "([^\"]*)"$/ do |content|
  assert_contain(content)
end
