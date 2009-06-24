Given /^I am a new visitor$/ do
  clear_cookies
end

When /^I view "([^\"]*)"$/ do |path|
  get path
end

When /^I (post|put) to "([^\"]*)":$/ do |meth, path, params|
  send(meth, path, params.hashes.inject({}){|h,e| h[e["key"]] = e["value"]; h})
end

Then /^I should see "([^\"]*)"$/ do |string|
  assert_match(string, last_response.body)
end
