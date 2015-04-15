require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given(/^I am on (.+)$/) do |page_name|
	visit path_to(page_name)
end

Then(/^I should see "([^\"]*)"$/) do |text|
	page.should have_content(text)
end
