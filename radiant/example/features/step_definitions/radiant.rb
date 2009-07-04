Given /^I have a layout$/ do
  Layout.create!(:name => "basic", :content => <<EOC)
<r:content />
EOC
end

Given /^a page at "([^\"]*)" containing:$/ do |path, content|
  page = Page.create!(:title => "test", :breadcrumb => "test", :slug => path, :status_id => 100)
  page.parts.create!(:name => "body", :content => content)
end

When /^there is an empty Radiant cache$/ do
  Radiant::Cache.clear
end