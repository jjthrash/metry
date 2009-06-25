Given /^I am a new visitor$/ do
  clear_cookies
end

When /^I view "([^\"]*)"$/ do |path|
  visit(path)
end

When /^I (post|put) to "([^\"]*)":$/ do |meth, path, params|
  send(meth, path, params.hashes.inject({}){|h,e| h[e["key"]] = e["value"]; h})
end

Then /^I should see "([^\"]*)"$/ do |string|
  assert_match(string, last_response.body)
end

When /^I follow "([^\"]*)"$/ do |link|
  click_link(link)
end

When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^I press "([^\"]*)"$/ do |button|
  click_button(button)
end

Then /^I should be on "([^\"]*)"$/ do |path|
  assert_equal path, last_response.path
end
