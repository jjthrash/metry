Given /^a page at "([^\"]*)" containing:$/ do |path, content|
  page = Page.create!(:title => "test", :breadcrumb => "test", :slug => path, :status_id => 100)
  page.parts.create!(:name => "body", :content => content)
end

When /^there is an empty Radiant cache$/ do
  Radiant::Cache.clear
end

Given /^I log in as an admin$/ do
  visit '/admin/login'
  fill_in 'Username', :with => 'admin'
  fill_in 'Password', :with => 'radiant'
  click_button 'Login'
  Then(%(I should be on "/admin/pages"))
end

When /^I log out$/ do
  visit "/admin/logout"
end